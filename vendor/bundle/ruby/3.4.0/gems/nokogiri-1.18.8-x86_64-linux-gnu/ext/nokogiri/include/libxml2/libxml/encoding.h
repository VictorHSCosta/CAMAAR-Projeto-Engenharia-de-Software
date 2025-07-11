/*
 * Summary: interface for the encoding conversion functions
 * Description: interface for the encoding conversion functions needed for
 *              XML basic encoding and iconv() support.
 *
 * Related specs are
 * rfc2044        (UTF-8 and UTF-16) F. Yergeau Alis Technologies
 * [ISO-10646]    UTF-8 and UTF-16 in Annexes
 * [ISO-8859-1]   ISO Latin-1 characters codes.
 * [UNICODE]      The Unicode Consortium, "The Unicode Standard --
 *                Worldwide Character Encoding -- Version 1.0", Addison-
 *                Wesley, Volume 1, 1991, Volume 2, 1992.  UTF-8 is
 *                described in Unicode Technical Report #4.
 * [US-ASCII]     Coded Character Set--7-bit American Standard Code for
 *                Information Interchange, ANSI X3.4-1986.
 *
 * Copy: See Copyright for the status of this software.
 *
 * Author: Daniel Veillard
 */

#ifndef __XML_CHAR_ENCODING_H__
#define __XML_CHAR_ENCODING_H__

#include <libxml/xmlversion.h>

#ifdef LIBXML_ICONV_ENABLED
#include <iconv.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
    XML_ENC_ERR_SUCCESS     =  0,
    XML_ENC_ERR_SPACE       = -1,
    XML_ENC_ERR_INPUT       = -2,
    XML_ENC_ERR_PARTIAL     = -3,
    XML_ENC_ERR_INTERNAL    = -4,
    XML_ENC_ERR_MEMORY      = -5
} xmlCharEncError;

/*
 * xmlCharEncoding:
 *
 * Predefined values for some standard encodings.
 * Libxml does not do beforehand translation on UTF8 and ISOLatinX.
 * It also supports ASCII, ISO-8859-1, and UTF16 (LE and BE) by default.
 *
 * Anything else would have to be translated to UTF8 before being
 * given to the parser itself. The BOM for UTF16 and the encoding
 * declaration are looked at and a converter is looked for at that
 * point. If not found the parser stops here as asked by the XML REC. A
 * converter can be registered by the user using xmlRegisterCharEncodingHandler
 * but the current form doesn't allow stateful transcoding (a serious
 * problem agreed !). If iconv has been found it will be used
 * automatically and allow stateful transcoding, the simplest is then
 * to be sure to enable iconv and to provide iconv libs for the encoding
 * support needed.
 *
 * Note that the generic "UTF-16" is not a predefined value.  Instead, only
 * the specific UTF-16LE and UTF-16BE are present.
 */
typedef enum {
    XML_CHAR_ENCODING_ERROR=   -1, /* No char encoding detected */
    XML_CHAR_ENCODING_NONE=	0, /* No char encoding detected */
    XML_CHAR_ENCODING_UTF8=	1, /* UTF-8 */
    XML_CHAR_ENCODING_UTF16LE=	2, /* UTF-16 little endian */
    XML_CHAR_ENCODING_UTF16BE=	3, /* UTF-16 big endian */
    XML_CHAR_ENCODING_UCS4LE=	4, /* UCS-4 little endian */
    XML_CHAR_ENCODING_UCS4BE=	5, /* UCS-4 big endian */
    XML_CHAR_ENCODING_EBCDIC=	6, /* EBCDIC uh! */
    XML_CHAR_ENCODING_UCS4_2143=7, /* UCS-4 unusual ordering */
    XML_CHAR_ENCODING_UCS4_3412=8, /* UCS-4 unusual ordering */
    XML_CHAR_ENCODING_UCS2=	9, /* UCS-2 */
    XML_CHAR_ENCODING_8859_1=	10,/* ISO-8859-1 ISO Latin 1 */
    XML_CHAR_ENCODING_8859_2=	11,/* ISO-8859-2 ISO Latin 2 */
    XML_CHAR_ENCODING_8859_3=	12,/* ISO-8859-3 */
    XML_CHAR_ENCODING_8859_4=	13,/* ISO-8859-4 */
    XML_CHAR_ENCODING_8859_5=	14,/* ISO-8859-5 */
    XML_CHAR_ENCODING_8859_6=	15,/* ISO-8859-6 */
    XML_CHAR_ENCODING_8859_7=	16,/* ISO-8859-7 */
    XML_CHAR_ENCODING_8859_8=	17,/* ISO-8859-8 */
    XML_CHAR_ENCODING_8859_9=	18,/* ISO-8859-9 */
    XML_CHAR_ENCODING_2022_JP=  19,/* ISO-2022-JP */
    XML_CHAR_ENCODING_SHIFT_JIS=20,/* Shift_JIS */
    XML_CHAR_ENCODING_EUC_JP=   21,/* EUC-JP */
    XML_CHAR_ENCODING_ASCII=    22 /* pure ASCII */
} xmlCharEncoding;

/**
 * xmlCharEncodingInputFunc:
 * @out:  a pointer to an array of bytes to store the UTF-8 result
 * @outlen:  the length of @out
 * @in:  a pointer to an array of chars in the original encoding
 * @inlen:  the length of @in
 *
 * Take a block of chars in the original encoding and try to convert
 * it to an UTF-8 block of chars out.
 *
 * Returns the number of bytes written, -1 if lack of space, or -2
 *     if the transcoding failed.
 * The value of @inlen after return is the number of octets consumed
 *     if the return value is positive, else unpredictiable.
 * The value of @outlen after return is the number of octets consumed.
 */
typedef int (* xmlCharEncodingInputFunc)(unsigned char *out, int *outlen,
                                         const unsigned char *in, int *inlen);


/**
 * xmlCharEncodingOutputFunc:
 * @out:  a pointer to an array of bytes to store the result
 * @outlen:  the length of @out
 * @in:  a pointer to an array of UTF-8 chars
 * @inlen:  the length of @in
 *
 * Take a block of UTF-8 chars in and try to convert it to another
 * encoding.
 * Note: a first call designed to produce heading info is called with
 * in = NULL. If stateful this should also initialize the encoder state.
 *
 * Returns the number of bytes written, -1 if lack of space, or -2
 *     if the transcoding failed.
 * The value of @inlen after return is the number of octets consumed
 *     if the return value is positive, else unpredictiable.
 * The value of @outlen after return is the number of octets produced.
 */
typedef int (* xmlCharEncodingOutputFunc)(unsigned char *out, int *outlen,
                                          const unsigned char *in, int *inlen);


/*
 * Block defining the handlers for non UTF-8 encodings.
 * If iconv is supported, there are two extra fields.
 */
typedef struct _xmlCharEncodingHandler xmlCharEncodingHandler;
typedef xmlCharEncodingHandler *xmlCharEncodingHandlerPtr;
struct _xmlCharEncodingHandler {
    char                       *name;
    xmlCharEncodingInputFunc   input;
    xmlCharEncodingOutputFunc  output;
#ifdef LIBXML_ICONV_ENABLED
    iconv_t                    iconv_in;
    iconv_t                    iconv_out;
#endif /* LIBXML_ICONV_ENABLED */
#ifdef LIBXML_ICU_ENABLED
    struct _uconv_t            *uconv_in;
    struct _uconv_t            *uconv_out;
#endif /* LIBXML_ICU_ENABLED */
};

/*
 * Interfaces for encoding handlers.
 */
XML_DEPRECATED
XMLPUBFUN void
	xmlInitCharEncodingHandlers	(void);
XML_DEPRECATED
XMLPUBFUN void
	xmlCleanupCharEncodingHandlers	(void);
XMLPUBFUN void
	xmlRegisterCharEncodingHandler	(xmlCharEncodingHandlerPtr handler);
XMLPUBFUN int
	xmlLookupCharEncodingHandler	(xmlCharEncoding enc,
					 xmlCharEncodingHandlerPtr *out);
XMLPUBFUN int
	xmlOpenCharEncodingHandler	(const char *name,
					 int output,
					 xmlCharEncodingHandlerPtr *out);
XMLPUBFUN xmlCharEncodingHandlerPtr
	xmlGetCharEncodingHandler	(xmlCharEncoding enc);
XMLPUBFUN xmlCharEncodingHandlerPtr
	xmlFindCharEncodingHandler	(const char *name);
XMLPUBFUN xmlCharEncodingHandlerPtr
	xmlNewCharEncodingHandler	(const char *name,
					 xmlCharEncodingInputFunc input,
					 xmlCharEncodingOutputFunc output);

/*
 * Interfaces for encoding names and aliases.
 */
XMLPUBFUN int
	xmlAddEncodingAlias		(const char *name,
					 const char *alias);
XMLPUBFUN int
	xmlDelEncodingAlias		(const char *alias);
XMLPUBFUN const char *
	xmlGetEncodingAlias		(const char *alias);
XMLPUBFUN void
	xmlCleanupEncodingAliases	(void);
XMLPUBFUN xmlCharEncoding
	xmlParseCharEncoding		(const char *name);
XMLPUBFUN const char *
	xmlGetCharEncodingName		(xmlCharEncoding enc);

/*
 * Interfaces directly used by the parsers.
 */
XMLPUBFUN xmlCharEncoding
	xmlDetectCharEncoding		(const unsigned char *in,
					 int len);

/** DOC_DISABLE */
struct _xmlBuffer;
/** DOC_ENABLE */
XMLPUBFUN int
	xmlCharEncOutFunc		(xmlCharEncodingHandler *handler,
					 struct _xmlBuffer *out,
					 struct _xmlBuffer *in);

XMLPUBFUN int
	xmlCharEncInFunc		(xmlCharEncodingHandler *handler,
					 struct _xmlBuffer *out,
					 struct _xmlBuffer *in);
XML_DEPRECATED
XMLPUBFUN int
	xmlCharEncFirstLine		(xmlCharEncodingHandler *handler,
					 struct _xmlBuffer *out,
					 struct _xmlBuffer *in);
XMLPUBFUN int
	xmlCharEncCloseFunc		(xmlCharEncodingHandler *handler);

/*
 * Export a few useful functions
 */
#ifdef LIBXML_OUTPUT_ENABLED
XMLPUBFUN int
	UTF8Toisolat1			(unsigned char *out,
					 int *outlen,
					 const unsigned char *in,
					 int *inlen);
#endif /* LIBXML_OUTPUT_ENABLED */
XMLPUBFUN int
	isolat1ToUTF8			(unsigned char *out,
					 int *outlen,
					 const unsigned char *in,
					 int *inlen);
#ifdef __cplusplus
}
#endif

#endif /* __XML_CHAR_ENCODING_H__ */
