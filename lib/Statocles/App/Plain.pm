package Statocles::App::Plain;
# ABSTRACT: Plain documents made into pages with no extras

use Statocles::Base 'Class';
extends 'Statocles::App';
use List::Util qw( first );
use Statocles::Page::Document;

=attr url_root

The root URL for this application. Required.

=cut

has url_root => (
    is => 'ro',
    isa => Str,
    required => 1,
);

=attr store

The L<store|Statocles::Store> containing this app's documents. Required.

=cut

has store => (
    is => 'ro',
    isa => Store,
    required => 1,
    coerce => Store->coercion,
);

=method pages

Get the L<pages|Statocles::Page> for this app.

=cut

sub pages {
    my ( $self ) = @_;
    my @pages;

    for my $doc ( @{ $self->store->documents } ) {
        my $url = $doc->path;
        $url =~ s/[.]markdown$/.html/;

        my $page = Statocles::Page::Document->new(
            app => $self,
            path => join( '/', $self->url_root, $url ),
            document => $doc,
            layout => $self->site->theme->template( site => 'layout.html' ),
        );

        if ( $url eq 'index.html' ) {
            unshift @pages, $page;
        }
        else {
            push @pages, $page;
        }
    }

    return @pages;
}

1;
__END__

=head1 SYNOPSIS

    my $app = Statocles::App::Plain->new(
        url_root => '/',
        store => 'share/root',
    );
    my @pages = $app->pages;

=head1 DESCRIPTION

This application builds simple pages based on L<documents|Statocles::Document>. Use this
to have basic informational pages like "About Us" and "Contact Us".

