package Algorithm::CRF;

use 5.008008;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Algorithm::CRF ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';

require XSLoader;
XSLoader::load('Algorithm::CRF', $VERSION);

# Preloaded methods go here.
#sub 
#CRFpp_Learn {
#    my $params = $_;
##    my @params = @_;
#    #   crfpp_learn($#params, $_);
#    $params = "-t -c 10.0 template train.data model";
#    print STDERR $params."\n";
#    my $k = crfpp_learn($params);
#    print STDERR "return $k \n";
#    return $k;
#}

sub new {
  my $package = shift;
  my $self = bless {
		    @_,
		    features => {},
		    rfeatures => [undef],
		   }, $package;
  $self->_param_init;
  return $self;
}

my @params = 
  qw(
	freq
	maxiter
	cost
	eta
	convert
	textmodel
	version
	help
    );


sub _param_init {
  my $self = shift;
  foreach my $param (@params) {
    if (exists $self->{$param}) {
      my $method = "set_$param";
      $self->$method($self->{$param});
    }
  }
}

sub is_trained {
  my $self = shift;
  return exists $self->{_model};
}

sub feature_names {
  my $self = shift;
  return keys %{ $self->{features} };
}

sub predict {
  my ($self, %params) = @_;
  for ('attributes') {
    die "Missing required '$_' parameter" unless exists $params{$_};
  }
  
  my (@values, @indices);
  while (my ($key) = each %{ $params{attributes} }) {
    push @indices, $self->{features}{$key} if exists $self->{features}{$key};
  }

  @indices = sort {$a <=> $b} @indices;
  foreach my $i (@indices) {
    push @values, $params{attributes}{ $self->{rfeatures}[$i] };
  }

  # warn "Predicting: (@indices), (@values)\n";
  $self->predict_i(\@indices, \@values);
}

sub add_instance {
  my ($self, %params) = @_;
  for ('attributes', 'label') {
    die "Missing required '$_' parameter" unless exists $params{$_};
  }
  for ($params{label}) {
    die "Label must be a real number, not '$_'" unless /^-?\d+(\.\d+)?$/;
  }
  
  my @values;
  my @indices;
  while (my ($key, $val) = each %{ $params{attributes} }) {
    unless ( exists $self->{features}{$key} ) {
      $self->{features}{$key} = 1 + keys %{ $self->{features} };
      push @{ $self->{rfeatures} }, $key;
    }
    push @indices, $self->{features}{$key};
  }

  @indices = sort { $a <=> $b} @indices;
  foreach my $i (@indices) {
    push @values, $params{attributes}{ $self->{rfeatures}[$i] };
  }

  #warn "Adding document: (@indices), (@values) => $params{label}\n";
  $self->add_instance_i($params{label}, "", \@indices, \@values);
}

sub write_model {
  my ($self, $file) = @_;
  $self->_write_model($file);

  # Write a footer line
  if ( my $numf = keys %{ $self->{features} } ) {
    open my($fh), ">> $file" or die "Can't write footer to $file: $!";
    print $fh ('#rfeatures: [undef, ' ,
	       join( ', ', map _escape($self->{rfeatures}[$_]), 1..$numf ),
	       "]\n");
  }
}

sub read_model {
  my ($self, $file) = @_;
  $self->_read_model($file);

  # Read the footer line
  open my($fh), $file or die "Can't read $file: $!";
  local $_;
  while (<$fh>) {
    next unless /^#rfeatures: (\[.*\])$/;
    my $rf = $self->{rfeatures} = eval $1;
    die $@ if $@;
    $self->{features} = { map {$rf->[$_], $_} 1..$#$rf };
  }
}

sub _escape {
  local $_ = shift;
  s/([\\'])/\\$1/g;
  s/\n/\\n/g;
  s/\r/\\r/g;
  return "'$_'";
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Algorithm::CRF - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Algorithm::CRF;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Algorithm::CRF, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Cheng-Lung Sung, E<lt>clsung@FreeBSD.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 by Cheng-Lung Sung

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
