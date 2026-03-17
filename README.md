# NAME

Data::Hash::Diff::Smart - Smart structural diff for Perl data structures

# SYNOPSIS

    use Data::Hash::Diff::Smart qw(diff diff_text diff_json diff_yaml diff_test2);

    my $changes = diff($old, $new);

    print diff_text($old, $new);

    my $json = diff_json($old, $new);

    my $yaml = diff_yaml($old, $new);

    diag diff_test2($old, $new);

# DESCRIPTION

`Data::Hash::Diff::Smart` provides a modern, recursive, configurable diff
engine for Perl data structures. It understands nested hashes, arrays,
scalars, objects, and supports ignore rules, custom comparators, and
multiple array diffing strategies.

The diff engine produces a stable, structured list of change operations,
which can be rendered as text, JSON, YAML, or Test2 diagnostics.

# FUNCTIONS

## diff($old, $new, %opts)

Compute a structural diff between two Perl data structures.

Returns an arrayref of change operations:

    [
        { op => 'change', path => '/user/name', from => 'Nigel', to => 'N. Horne' },
        { op => 'add',    path => '/tags/2',    value => 'admin' },
        { op => 'remove', path => '/debug',     from  => 1 },
    ]

### Options

- ignore => \[ '/path', qr{^/debug}, '/foo/\*/bar' \]

    Ignore specific paths. Supports exact paths, regexes, and wildcard
    segments.

- compare => { '/price' => sub { abs($\_\[0\] - $\_\[1\]) < 0.01 } }

    Custom comparator callbacks for specific paths.

- array\_mode => 'index' | 'lcs' | 'unordered'

    Choose how arrays are diffed:

    - index - compare by index (default)
    - lcs - minimal diff using Longest Common Subsequence
    - unordered - treat arrays as multisets (order ignored)

## diff\_text($old, $new, %opts)

Render the diff as a human-readable text format.

## diff\_json($old, $new, %opts)

Render the diff as JSON using `JSON::MaybeXS`.

## diff\_yaml($old, $new, %opts)

Render the diff as YAML using `YAML::XS`.

## diff\_test2($old, $new, %opts)

Render the diff as Test2 diagnostics suitable for `diag`.

# INTERNALS

The diff engine lives in [Data::Hash::Diff::Smart::Engine](https://metacpan.org/pod/Data%3A%3AHash%3A%3ADiff%3A%3ASmart%3A%3AEngine).

# AUTHOR

Nigel Horne

# LICENSE

This library is free software; you may redistribute it under the same
terms as Perl itself.
