#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <iconv.h>

extern void *HttpRequestParse(char *ptr, long int len);
void HttpUrlDecode(char *text);

void *HttpRequestParse(char *ptr, long int len) {
  char *content_type, *ct, *k, *v, *r;
  long int i, p, ks, kl, vs, vl, c, l, ctl;

  c = 0;
  l = 4;
  r = (char *) malloc(4);

  ctl = 0;
  ct = getenv("CONTENT_TYPE");
  if (ct) {
    content_type = (char *) malloc(strlen(ct)+1);
    strcpy(content_type, ct);
    for(i=0; content_type[i] != '\0'; i++)
      content_type[i] = tolower(content_type[i]);
    for(; (content_type[ctl] != ';') && (content_type[ctl] != '\0'); ctl++);
    ctl--;
  }
  else content_type = NULL;

  if ((content_type == NULL) || (memcmp(content_type, "application/x-www-form-urlencoded", ctl) == 0)) {
    p = 0;
    if (strcmp(getenv("REQUEST_METHOD"), "GET") == 0) {
      for(; ptr[p] != '?' && ptr[p] != '\0'; p++);
      if (ptr[p] == '?')
        p++;
    }
    for(; ptr[p] != '\0';) {
      // key
      for(ks=p, kl=0; ptr[p] != '=' && ptr[p] != '&' && ptr[p] != '\0'; kl++, p++);
      k = (char *) malloc(kl+1);
      memcpy(k, &ptr[ks], kl);
      k[kl] = '\0';
      HttpUrlDecode(k);
      for(i=0; i<strlen(k); i++)
        k[i] = toupper(k[i]);
      kl = strlen(k) + 1;
      r = realloc(r, l + 4 + kl);
      memcpy(&r[l], &kl, 4);
      strcpy(&r[l+4], k);
      l += 4 + kl;
      free(k);
      c++;
      if (ptr[p] == '=') {
        // value
        p++;
        for(vs=p, vl=0; ptr[p] != '&' && ptr[p] != '\0'; vl++, p++);
        v = (char *) malloc(vl+1);
        memcpy(v, &ptr[vs], vl);
        v[vl] = '\0';
        HttpUrlDecode(v);
        vl = strlen(v) + 1;
        r = realloc(r, l + 4 + vl);
        memcpy(&r[l], &vl, 4);
        strcpy(&r[l+4], v);
        l += 4 + vl;
        free(v);
      }
      else {
        // no value
        vl = 0;
        r = realloc(r, l + 4);
        memcpy(&r[l], &vl, 4);
        l += 4;
      }
      if (ptr[p] == '&')
        p++;
    }
  }

  memcpy(r, &c, 4);

  free(content_type);

  return r;
}

void HttpUrlDecode(char *text) {
  int p, h, l, t;
  char hexdigits[17] = "0123456789ABCDEF";
  iconv_t cvt;
  char c1[32], c2[32];
  unsigned int in, out;
  char *from, *to;

  memset(c1, '0', 32);
  memcpy(c1, "IBMCCSID", 8);
  memcpy(&c1[8], "00819", 5);
  memset(c2, '0', 32);
  memcpy(c2, "IBMCCSID", 8);
  memcpy(&c2[8], "00000", 5);
  cvt = iconv_open(c2, c1);

  for(p=0, t=0; text[p] != '\0'; p++, t++) {
    if (text[p] == '+')
      text[t] = ' ';
    else if ((text[p] == '%') && (text[p+1] != '\0') && (text[p+2] != '\0')) {
      h = strchr(hexdigits, toupper(text[p+1])) - hexdigits;
      l = strchr(hexdigits, toupper(text[p+2])) - hexdigits;
      text[t] = 16 * h + l;
      from = &text[t];
      in = 1;
      to = &text[t];
      iconv(cvt, &from, &in, &to, &out);
      p += 2;
    }
    else text[t] = text[p];
  }
  text[t] = '\0';

  iconv_close(cvt);
}
