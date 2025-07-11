# Diff::LCS

- home :: https://github.com/halostatue/diff-lcs
- changelog :: https://github.com/halostatue/diff-lcs/blob/main/CHANGELOG.md
- code :: https://github.com/halostatue/diff-lcs
- bugs :: https://github.com/halostatue/diff-lcs/issues
- rdoc :: http://rubydoc.info/github/halostatue/diff-lcs

<a href="https://github.com/halostatue/diff-lcs/actions">
  <img src="https://github.com/halostatue/diff-lcs/workflows/CI/badge.svg" />
</a>

## Description

Diff::LCS computes the difference between two Enumerable sequences using the
McIlroy-Hunt longest common subsequence (LCS) algorithm. It includes utilities
to create a simple HTML diff output format and a standard diff-like tool.

This is release 1.6.1, providing a simple extension that allows for
Diff::LCS::Change objects to be treated implicitly as arrays and fixes a number
of formatting issues.

Ruby versions below 2.5 are soft-deprecated, which means that older versions are
no longer part of the CI test suite. If any changes have been introduced that
break those versions, bug reports and patches will be accepted, but it will be
up to the reporter to verify any fixes prior to release. The next major release
will completely break compatibility.

## Synopsis

Using this module is quite simple. By default, Diff::LCS does not extend objects
with the Diff::LCS interface, but will be called as if it were a function:

```ruby
require 'diff/lcs'

seq1 = %w(a b c e h j l m n p)
seq2 = %w(b c d e f j k l m r s t)

lcs = Diff::LCS.LCS(seq1, seq2)
diffs = Diff::LCS.diff(seq1, seq2)
sdiff = Diff::LCS.sdiff(seq1, seq2)
seq = Diff::LCS.traverse_sequences(seq1, seq2, callback_obj)
bal = Diff::LCS.traverse_balanced(seq1, seq2, callback_obj)
seq2 == Diff::LCS.patch!(seq1, diffs)
seq1 == Diff::LCS.unpatch!(seq2, diffs)
seq2 == Diff::LCS.patch!(seq1, sdiff)
seq1 == Diff::LCS.unpatch!(seq2, sdiff)
```

Objects can be extended with Diff::LCS:

```ruby
seq1.extend(Diff::LCS)
lcs = seq1.lcs(seq2)
diffs = seq1.diff(seq2)
sdiff = seq1.sdiff(seq2)
seq = seq1.traverse_sequences(seq2, callback_obj)
bal = seq1.traverse_balanced(seq2, callback_obj)
seq2 == seq1.patch!(diffs)
seq1 == seq2.unpatch!(diffs)
seq2 == seq1.patch!(sdiff)
seq1 == seq2.unpatch!(sdiff)
```

By requiring 'diff/lcs/array' or 'diff/lcs/string', Array or String will be
extended for use this way.

Note that Diff::LCS requires a sequenced enumerable container, which means that
the order of enumeration is both predictable and consistent for the same set of
data. While it is theoretically possible to generate a diff for an unordered
hash, it will only be meaningful if the enumeration of the hashes is consistent.
In general, this will mean that containers that behave like String or Array will
perform best.

## History

Diff::LCS is a port of Perl's Algorithm::Diff that uses the McIlroy-Hunt longest
common subsequence (LCS) algorithm to compute intelligent differences between
two sequenced enumerable containers. The implementation is based on Mario I.
Wolczko's [Smalltalk version 1.2][smalltalk] (1993) and Ned Konz's Perl version
[Algorithm::Diff 1.15][perl]. `Diff::LCS#sdiff` and
`Diff::LCS#traverse_balanced` were originally written for the Perl version by
Mike Schilli.

The algorithm is described in <em>A Fast Algorithm for Computing Longest Common
Subsequences</em>, CACM, vol.20, no.5, pp.350-353, May 1977, with a few minor
improvements to improve the speed. A simplified description of the algorithm,
originally written for the Perl version, was written by Mark-Jason Dominus.

[smalltalk]: ftp://st.cs.uiuc.edu/pub/Smalltalk/MANCHESTER/manchester/4.0/diff.st
[perl]: http://search.cpan.org/~nedkonz/Algorithm-Diff-1.15/
