package Data::Hash::Diff::Smart::Engine;

use strict;
use warnings;

use Scalar::Util qw(reftype blessed);
use Data::Hash::Diff::Smart::Path ();

sub diff {
    my ($old, $new, %opts) = @_;

    my $changes = [];

    my $ctx = {
        ignore   => _normalize_ignore($opts{ignore}),
        compare  => $opts{compare} || {},
        array_mode => $opts{array_mode} || 'index',
    };

    _diff($old, $new, '', $changes, $ctx);

    return $changes;
}

# -------------------------------------------------------------------------
# Internal: recursive diff
# -------------------------------------------------------------------------

sub _diff {
    my ($old, $new, $path, $changes, $ctx) = @_;

    # Ignore rules
    return if _is_ignored($path, $ctx->{ignore});

    my $rt_old = _reftype($old);
    my $rt_new = _reftype($new);

    # Both non-refs (scalars)
    if (!$rt_old && !$rt_new) {
        return _diff_scalar($old, $new, $path, $changes, $ctx);
    }

    # Type mismatch
    if ($rt_old && $rt_new && $rt_old ne $rt_new) {
        push @$changes, {
            op   => 'change',
            path => $path,
            from => $old,
            to   => $new,
        };
        return;
    }

    # One is ref, other is not
    if ($rt_old && !$rt_new) {
        push @$changes, {
            op   => 'change',
            path => $path,
            from => $old,
            to   => $new,
        };
        return;
    }

    if (!$rt_old && $rt_new) {
        push @$changes, {
            op   => 'change',
            path => $path,
            from => $old,
            to   => $new,
        };
        return;
    }

    # Both refs, same type
    if ($rt_old eq 'HASH') {
        return _diff_hash($old, $new, $path, $changes, $ctx);
    }

    if ($rt_old eq 'ARRAY') {
        return _diff_array($old, $new, $path, $changes, $ctx);
    }

    # Fallback: compare stringified
    return _diff_scalar("$old", "$new", $path, $changes, $ctx);
}

# -------------------------------------------------------------------------
# Scalar comparison (with optional custom comparator)
# -------------------------------------------------------------------------

sub _diff_scalar {
    my ($old, $new, $path, $changes, $ctx) = @_;

    # Custom comparator for this path?
    if (my $cmp = $ctx->{compare}{$path}) {
        my $same = eval { $cmp->($old, $new) };
        if ($@) {
            # If comparator dies, treat as change
            push @$changes, {
                op   => 'change',
                path => $path,
                from => $old,
                to   => $new,
                error => "$@",
            };
            return;
        }
        return if $same;
    } else {
        # Default comparison
        return if _eq($old, $new);
    }

    push @$changes, {
        op   => 'change',
        path => $path,
        from => $old,
        to   => $new,
    };
}

# -------------------------------------------------------------------------
# Hash comparison
# -------------------------------------------------------------------------

sub _diff_hash {
    my ($old, $new, $path, $changes, $ctx) = @_;

    my %keys;
    $keys{$_}++ for keys %$old;
    $keys{$_}++ for keys %$new;

    for my $k (sort keys %keys) {
        my $subpath = Data::Hash::Diff::Smart::Path::join($path, $k);

        if (exists $old->{$k} && exists $new->{$k}) {
            _diff($old->{$k}, $new->{$k}, $subpath, $changes, $ctx);
        }
        elsif (exists $old->{$k}) {
            push @$changes, {
                op   => 'remove',
                path => $subpath,
                from => $old->{$k},
            };
        }
        else {
            push @$changes, {
                op    => 'add',
                path  => $subpath,
                value => $new->{$k},
            };
        }
    }
}

# -------------------------------------------------------------------------
# Array comparison (index mode)
# -------------------------------------------------------------------------

sub _diff_array {
    my ($old, $new, $path, $changes, $ctx) = @_;

    my $mode = $ctx->{array_mode} || 'index';

    if ($mode eq 'index') {
        my $max = @$old > @$new ? @$old : @$new;

        for my $i (0 .. $max - 1) {
            my $subpath = Data::Hash::Diff::Smart::Path::join($path, $i);

            if ($i <= $#$old && $i <= $#$new) {
                _diff($old->[$i], $new->[$i], $subpath, $changes, $ctx);
            }
            elsif ($i <= $#$old) {
                push @$changes, {
                    op   => 'remove',
                    path => $subpath,
                    from => $old->[$i],
                };
            }
            else {
                push @$changes, {
                    op    => 'add',
                    path  => $subpath,
                    value => $new->[$i],
                };
            }
        }
        return;
    }

    # Future modes (lcs, unordered) can go here
    die "Unsupported array_mode: $mode";
}

# -------------------------------------------------------------------------
# Helpers
# -------------------------------------------------------------------------

sub _reftype {
    my ($v) = @_;
    return unless ref $v;
    return reftype($v) || 'SCALAR';
}

sub _eq {
    my ($a, $b) = @_;
    return 1 if !defined($a) && !defined($b);
    return 0 if defined($a) xor defined($b);
    return $a eq $b;
}

# ignore => [ '/foo/bar', qr{^/debug}, ... ]
sub _normalize_ignore {
    my ($ignore) = @_;
    return [] unless $ignore;

    return [
        map {
            ref($_) eq 'Regexp' ? $_ : "$_"
        } @$ignore
    ];
}

sub _is_ignored {
    my ($path, $rules) = @_;
    return 0 unless $rules && @$rules;

    for my $r (@$rules) {
        if (ref($r) eq 'Regexp') {
            return 1 if $path =~ $r;
        } else {
            return 1 if $path eq $r;
        }
    }
    return 0;
}

1;
