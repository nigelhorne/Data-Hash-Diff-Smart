use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'Data::Hash::Diff::Smart',
    VERSION_FROM => 'lib/Data/Hash/Diff/Smart.pm',
    ABSTRACT     => 'Smart structural diff for Perl data structures',
    AUTHOR       => 'Nigel Horne',
    LICENSE      => 'perl',
    PREREQ_PM    => {
        'Exporter' => 0,
    },
);

