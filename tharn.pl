#!/usr/bin/env perl;
use Mojolicious::Lite;
use DBI;
use File::Pairtree;
use Mojo::UserAgent;

state $dbh = DBI->connect("dbi:SQLite:dbname=tharn.db","","");

my $static = app->static();
push @{ $static->paths }, "/home/serth/tharn.org/public/";

plugin 'Config';

plugin 'AssetPack';

my @js_files = (
    "https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.js",
    "https://cdnjs.cloudflare.com/ajax/libs/angular.js/1.3.15/angular.js",
    "https://cdnjs.cloudflare.com/ajax/libs/angular.js/1.3.15/angular-route.js",
    "https://cdnjs.cloudflare.com/ajax/libs/fabric.js/1.2.0/fabric.all.min.js",
    "js/tharn.js",
);

app->asset(
    'app.js' => @js_files
);


get '/' => sub {
    my $self = shift;
    $self->render('index');
};


get '/bigpicture' => sub {
    my $self = shift;

    my $sth = $dbh->prepare("select id, word from word where images >= 10 order by random() limit 1");
    $sth->execute;
    my ($id, $word) = $sth->fetchrow;

    $sth = $dbh->prepare("select file from image where word_id = ?");
    $sth->execute($id);
    my $images = $sth->fetchall_arrayref;


    my @images;
    for my $file (@$images) {
        $file->[0] =~ s/^\/home\/serth\/tharn\.org\/public//;
        push @images, $file->[0];
    }

    $self->render(json => {
        word    => $word,
        images  => \@images
    }, status => 200);
};


get '/fetch' => sub {
    my $self = shift;

    my $sth = $dbh->prepare("select word from word where images = 0 order by random() limit 1");
    $sth->execute;
    my $word = $sth->fetchrow;
   
    my $azure = plugin 'Config' => { file => 'azure.conf' };
    my $url = 'https://user:'
        . $azure->key
        . '@api.datamarket.azure.com/Data.ashx/Bing/Search/v1/Image?Query=%27'
        . $word
        .'%27&$top=20&$format=JSON';

    my $ua = Mojo::UserAgent->new;
    my $res = $ua->get($url)->res->json;
    
    $self->app->log->debug($res);
    
};


app->start;


__DATA__
@@ layouts/default.html.ep
<!doctype html>
<html>
    <head>
        <title><%= title %></title>
    </head>
    <body ng-app="Tharn">

        <div>
            <%= content %>
        </div>

        <%= asset 'app.js' %>
    </body>
</body>


@@ index.html.ep
% layout 'default';
% title 'tharn';
<ng-view></ng-view>


