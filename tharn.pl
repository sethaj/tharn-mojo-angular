!#/usr/bin/env perl;
use Mojolicious::Lite;
use DBI;
use File::Pairtree;

state $dbh = DBI->connect("dbi:SQLite:dbname=tharn.sqlite.2015-10-20.db","","");

my $static = app->static();
push @{ $static->paths }, "/home/serth/tharn.org/public/";

plugin 'AssetPack';

my @js_files = (
    "https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.js",
    "https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.4/js/bootstrap.js",
    "https://cdnjs.cloudflare.com/ajax/libs/angular.js/1.3.15/angular.js",
    "https://cdnjs.cloudflare.com/ajax/libs/angular.js/1.3.15/angular-route.js",
    "https://cdnjs.cloudflare.com/ajax/libs/fabric.js/1.2.0/fabric.all.min.js",
    "js/tharn.js",
    "js/bigpicture.js"
);

app->asset(
    'app.js' => @js_files
);

app->asset(
    'style.css' => (
        "https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.4/css/bootstrap.min.css",
        "https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.4/css/bootstrap-theme.min.css",
        "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.3.0/css/font-awesome.min.css",
    )
);



get '/' => sub {
    my $self = shift;
    $self->render('index');
}


get '/bigpicture' => sub {
    my $self = shift;
    my $word = $dbh->selectrow_hashref("select * from word order by RANDOM() limit 1");

    my $sth = $dbh->prepare("select file from image where word_id = ?");
    $sth->execute($word->{'id'});

    my @images;
    while (my $file = $sth->fetchrow) {
        $file =~ s/^\/home\/serth\/tharn\.org\/public//;
        push @images, $file;
    }

    $self->render(json => {
        word => $word->{'word'},
        images => $images
    }, status => 200);
}





__DATA__
@@ layouts/default.html.ep
<!doctype html>
<html>
    <head>
        <title><%= title %></title>
        <%= asset 'style.css' %>
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


