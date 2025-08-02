import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musiclove/features/listen_now/presentation/bloc/listen_now_bloc.dart';
import 'package:musiclove/features/listen_now/presentation/widgets/genre_block_item.dart';

class ListenNowPage extends StatefulWidget {
  const ListenNowPage({Key? key}) : super(key: key);

  @override
  _ListenNowPageState createState() => _ListenNowPageState();
}

class _ListenNowPageState extends State<ListenNowPage> {
  int counter = 0;
  List<String> genres = [
    "Hits",
    "Chill",
    "Pop",
    "Rock",
  ];

  List<Color> genresColor = [
    Colors.orange,
    Colors.cyan,
    Colors.redAccent,
    Colors.purpleAccent,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ListenNowBloc, ListenNowState>(
      listener: (context, state) {
        print(state.helloWorld);
      },
      builder: (context, state) {
        var bloc = context.read<ListenNowBloc>();

        Widget _body() {
          // return Column(
          //   children: [],
          // );
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 120,
                pinned: true,
                centerTitle: false,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  titlePadding: const EdgeInsets.only(
                    left: 18,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Listen Now',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.account_circle_rounded,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 18,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Stations by Genre",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 258,
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => GenreBlockItem(
                            title: genres[index],
                            color: genresColor[index],
                          ),
                          separatorBuilder: (context, index) => SizedBox(
                            width: 10,
                          ),
                          itemCount: genres.length,
                        ),
                      ),
                      // GenreBlockItem(title: "Hits"),
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              ),
              // SliverList.builder(

              //   itemBuilder: (context, index) => GenreBlockItem(title: "Hits"),
              // ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 18,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Top Songs by City",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 258,
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) =>
                              GenreBlockItem(title: "Hits"),
                          separatorBuilder: (context, index) => SizedBox(
                            width: 10,
                          ),
                          itemCount: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverFillRemaining(),
            ],
          );
        }

        return Scaffold(
          body: _body(),
          // body: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Container(
          //       child: Center(
          //         child: Text("This is listen now ${state.helloWorld}"),
          //       ),
          //     ),
          //     ElevatedButton(
          //       onPressed: () {
          //         bloc.add(
          //           ListenNowEvent.printHelloWorld("Hello stuff ${counter++}"),
          //         );
          //       },
          //       child: Text('Hello World'),
          //     ),
          //   ],
          // ),
        );
      },
    );
  }
}
