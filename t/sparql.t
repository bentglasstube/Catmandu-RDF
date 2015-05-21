use strict;
use warnings;
use Test::More;
use Catmandu -all;

my $sparql   =<<END;
PREFIX dc: <http://purl.org/dc/elements/1.1/>
SELECT * WHERE { ?book dc:title ?title . }
END

{
    my $url = 'http://sparql.org/books/sparql';

    my $importer = importer('RDF', url => $url, sparql => $sparql);
    is $importer->sparql, $sparql, "SPARQL";

    $importer = importer('RDF', url => $url, 
        sparql => "SELECT * WHERE { ?book dc:title ?title . }\n");
    is $importer->sparql, $sparql, "SPARQL, PREFIX added";

    if ($ENV{RELEASE_TESTING}) {
        my $ref = $importer->first;
        ok $ref->{title} , 'got a title';
        ok $ref->{book} , 'got a book';
    } else {
        note "skipping SPARQL from URL test for release testing";
    }
}

 {
     $sparql =<<EOF;
SELECT ?film WHERE { ?film dct:subject <http://dbpedia.org/resource/Category:French_films> }
EOF
     my $url = 'http://fragments.dbpedia.org/2014/en';

     my $importer = importer('RDF', url => $url, sparql => $sparql);

     if ($ENV{RELEASE_TESTING}) {
          my $ref = $importer->first;
          ok $ref->{film} , 'got a film';
     } else {
         note "skipping SPARQL from URL test for release testing";
     }
}

done_testing;