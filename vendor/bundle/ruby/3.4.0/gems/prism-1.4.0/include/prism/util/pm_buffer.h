/**
 * @file pm_buffer.h
 *
 * A wrapper around a contiguous block of allocated memory.
 */
#ifndef PRISM_BUFFER_H
#define PRISM_BUFFER_H

#include "prism/defines.h"
#include "prism/util/pm_char.h"

#include <assert.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

/**
 * A pm_buffer_t is a simple memory buffer that stores data in a contiguous
 * block of memory.
 */
typedef struct {
    /** The length of the buffer in bytes. */
    size_t length;

    /** The capacity of the buffer in bytes that has been allocated. */
    size_t capacity;

    /** A pointer to the start of the buffer. */
    char *value;
} pm_buffer_t;

/**
 * Return the size of the pm_buffer_t struct.
 *
 * @returns The size of the pm_buffer_t struct.
 */
PRISM_EXPORTED_FUNCTION size_t pm_buffer_sizeof(void);

/**
 * Initialize a pm_buffer_t with the given capacity.
 *
 * @param buffer The buffer to initialize.
 * @param capacity The capacity of the buffer.
 * @returns True if the buffer was initialized successfully, false otherwise.
 */
bool pm_buffer_init_capacity(pm_buffer_t *buffer, size_t capacity);

/**
 * Initialize a pm_buffer_t with its default values.
 *
 * @param buffer The buffer to initialize.
 * @returns True if the buffer was initialized successfully, false otherwise.
 */
PRISM_EXPORTED_FUNCTION bool pm_buffer_init(pm_buffer_t *buffer);

/**
 * Return the value of the buffer.
 *
 * @param buffer The buffer to get the value of.
 * @returns The value of the buffer.
 */
PRISM_EXPORTED_FUNCTION char * pm_buffer_value(const pm_buffer_t *buffer);

/**
 * Return the length of the buffer.
 *
 * @param buffer The buffer to get the length of.
 * @returns The length of the buffer.
 */
PRISM_EXPORTED_FUNCTION size_t pm_buffer_length(const pm_buffer_t *buffer);

/**
 * Append the given amount of space as zeroes to the buffer.
 *
 * @param buffer The buffer to append to.
 * @param length The amount of space to append and zero.
 */
void pm_buffer_append_zeroes(pm_buffer_t *buffer, size_t length);

/**
 * Append a formatted string to the buffer.
 *
 * @param buffer The buffer to append to.
 * @param format The format string to append.
 * @param ... The arguments to the format string.
 */
void pm_buffer_append_format(pm_buffer_t *buffer, const char *format, ...) PRISM_ATTRIBUTE_FORMAT(2, 3);

/**
 * Append a string to the buffer.
 *
 * @param buffer The buffer to append to.
 * @param value The string to append.
 * @param length The length of the string to append.
 */
void pm_buffer_append_string(pm_buffer_t *buffer, const char *value, size_t length);

/**
 * Append a list of bytes to the buffer.
 *
 * @param buffer The buffer to append to.
 * @param value The bytes to append.
 * @param length The length of the bytes to append.
 */
void pm_buffer_append_bytes(pm_buffer_t *buffer, const uint8_t *value, size_t length);

/**
 * Append a single byte to the buffer.
 *
 * @param buffer The buffer to append to.
 * @param value The byte to append.
 */
void pm_buffer_append_byte(pm_buffer_t *buffer, uint8_t value);

/**
 * Append a 32-bit unsigned integer to the buffer as a variable-length integer.
 *
 * @param buffer The buffer to append to.
 * @param value The integer to append.
 */
void pm_buffer_append_varuint(pm_buffer_t *buffer, uint32_t value);

/**
 * Append a 32-bit signed integer to the buffer as a variable-length integer.
 *
 * @param buffer The buffer to append to.
 * @param value The integer to append.
 */
void pm_buffer_append_varsint(pm_buffer_t *buffer, int32_t value);

/**
 * Append a double to the buffer.
 *
 * @param buffer The buffer to append to.
 * @param value The double to append.
 */
void pm_buffer_append_double(pm_buffer_t *buffer, double value);

/**
 * Append a unicode codepoint to the buffer.
 *
 * @param buffer The buffer to append to.
 * @param value The character to append.
 * @returns True if the codepoint was valid and appended successfully, false
 *   otherwise.
 */
bool pm_buffer_append_unicode_codepoint(pm_buffer_t *buffer, uint32_t value);

/**
 * The different types of escaping that can be performed by the buffer when
 * appending a slice of Ruby source code.
 */
typedef enum {
    PM_BUFFER_ESCAPING_RUBY,
    PM_BUFFER_ESCAPING_JSON
} pm_buffer_escaping_t;

/**
 * Append a slice of source code to the buffer.
 *
 * @param buffer The buffer to append to.
 * @param source The source code to append.
 * @param length The length of the source code to append.
 * @param escaping The type of escaping to perform.
 */
void pm_buffer_append_source(pm_buffer_t *buffer, const uint8_t *source, size_t length, pm_buffer_escaping_t escaping);

/**
 * Prepend the given string to the buffer.
 *
 * @param buffer The buffer to prepend to.
 * @param value The string to prepend.
 * @param length The length of the string to prepend.
 */
void pm_buffer_prepend_string(pm_buffer_t *buffer, const char *value, size_t length);

/**
 * Concatenate one buffer onto another.
 *
 * @param destination The buffer to concatenate onto.
 * @param source The buffer to concatenate.
 */
void pm_buffer_concat(pm_buffer_t *destination, const pm_buffer_t *source);

/**
 * Clear the buffer by reducing its size to 0. This does not free the allocated
 * memory, but it does allow the buffer to be reused.
 *
 * @param buffer The buffer to clear.
 */
void pm_buffer_clear(pm_buffer_t *buffer);

/**
 * Strip the whitespace from the end of the buffer.
 *
 * @param buffer The buffer to strip.
 */
void pm_buffer_rstrip(pm_buffer_t *buffer);

/**
 * Checks if the buffer includes the given value.
 *
 * @param buffer The buffer to check.
 * @param value The value to check for.
 * @returns The index of the first occurrence of the value in the buffer, or
 *   SIZE_MAX if the value is not found.
 */
size_t pm_buffer_index(const pm_buffer_t *buffer, char value);

/**
 * Insert the given string into the buffer at the given index.
 *
 * @param buffer The buffer to insert into.
 * @param index The index to insert at.
 * @param value The string to insert.
 * @param length The length of the string to insert.
 */
void pm_buffer_insert(pm_buffer_t *buffer, size_t index, const char *value, size_t length);

/**
 * Free the memory associated with the buffer.
 *
 * @param buffer The buffer to free.
 */
PRISM_EXPORTED_FUNCTION void pm_buffer_free(pm_buffer_t *buffer);

#endif
