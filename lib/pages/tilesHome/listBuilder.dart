import 'package:flutter/material.dart';
import 'package:rssreaderfschmtz/classes/feed.dart';
import 'package:rssreaderfschmtz/pages/tilesHome/containerItemHome.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;

class ListBuilder extends StatefulWidget {
  @override
  _ListBuilderState createState() => _ListBuilderState();

  final String feedUrl;

  ListBuilder({Key key, this.feedUrl}) : super(key: key);
}

class _ListBuilderState extends State<ListBuilder>{
  bool carregando = true;
  Map<int, AtomItem> feedYoutube = new Map();

  @override
  void initState() {
    getRssYoutubeData();
    super.initState();
  }

  //Feed do Youtube sempre será de 15 items
  Future<void> getRssYoutubeData() async {
    var client = http.Client();
    var response = await client.get(widget.feedUrl);
    var channel = AtomFeed.parse(response.body);
    if (mounted) {
      setState(() {
        feedYoutube = channel.items.asMap();
        carregando = false;
      });
    }
    client.close();
  }


  @override
  Widget build(BuildContext context) {
    return carregando
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Text(
                  feedYoutube[0].authors[0].name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w600),
                ),
                ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
                    height: 5,
                  ),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: feedYoutube.length,
                  itemBuilder: (context, index) {
                    return ContainerItemHome(
                      feed: new Feed(
                        title: feedYoutube[index].title,
                        link: feedYoutube[index].links[0].href,
                        data: feedYoutube[index].published,
                        linkImagem: 'https://i.ytimg.com/vi/${feedYoutube[index].id.substring(9)}/hq720.jpg',
                      )
                    );
                  },
                ),
              ],
            ),
          );
  }
}

