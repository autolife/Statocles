package Statocles::Page;
# ABSTRACT: Render documents into HTML

use Statocles::Role;
use Statocles::Template;
use Text::Markdown;

requires 'render';

=attr path

The absolute URL path to save this page to.

=cut

has path => (
    is => 'ro',
    isa => Path,
    coerce => Path->coercion,
);

=attr markdown

The L<Text::Markdown> object to render document Markdown.

=cut

has markdown => (
    is => 'ro',
    isa => InstanceOf['Text::Markdown'],
    default => sub { Text::Markdown->new },
);

my @template_attrs = (
    is => 'ro',
    isa => InstanceOf['Statocles::Template'],
    coerce => sub {
        die "Template is undef" unless defined $_[0];
        return !ref $_[0]
            ? Statocles::Template->new( content => $_[0] )
            : $_[0]
            ;
    },
);

=attr template

The main L<template|Statocles::Template> for this page. The result will be
wrapped in the L<layout template|/layout>.

=cut

has template => @template_attrs;

=attr layout

The layout L<template|Statocles::Template> for this page, which will wrap the content generated by the
L<template|/template>.

=cut

has layout => (
    @template_attrs,
    default => sub {
        Statocles::Template->new( content => '<%= $content %>' ),
    },
);

1;
__END__

=head1 DESCRIPTION

A Statocles::Page takes one or more L<documents|Statocles::Document> and
renders them into one or more HTML pages using a main L<template|/template>
and a L<layout template|/layout>.

=head1 SEE ALSO

=over

=item L<Statocles::Page::Document>

A page that renders a single document.

=item L<Statocles::Page::List>

A page that renders a list of other pages.

=back

