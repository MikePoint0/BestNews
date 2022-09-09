
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import '../../data/models/GlobalFeedModel.dart';
import '../../domain/entities/helpers.dart';

Widget feedView(BuildContext context, List<Data> datas) {
  return Column(
    children: List.generate(datas.length, (index) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 30.0,
                          child:  ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: Image.network(datas[index].authorAvatarUrl!,
                                  fit: BoxFit.cover)),
                        ),
                        const Positioned(
                          right: 0.0,
                          bottom: 0.0,
                          child: Icon(Icons.verified_rounded,
                              color: Colors.blue,
                              size: 24),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                datas[index].authorName!,
                                style: const TextStyle(fontSize: 14, color: Colors.red),
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                "@${datas[index].authorName!}",
                                style: const TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            readTimestamp(datas[index].timestamp!),
                            style: const TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                    child: Icon(
                        datas[index].bookmarked!
                            ? Icons.bookmark_outlined
                            : Icons.bookmark_outline,
                    color: datas[index].bookmarked!
                        ? Colors.red
                        : Colors.grey,
                    size: 28))
              ],
            ),
            const SizedBox(height: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                datas[index].title! != null || datas[index].title! == ""
                    ? Text(
                toBeginningOfSentenceCase(datas[index].title!)!,
                  style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w800),
                ) : const SizedBox.shrink(),
                Html(data: toBeginningOfSentenceCase(datas[index].text!)!,
                    style: {
                      "body": Style(
                        fontSize: FontSize.large, color: Colors.white, fontWeight: FontWeight.w400,
                      ),
                      "p": Style(
                        fontSize: FontSize.medium, color: Colors.white, fontWeight: FontWeight.w400,
                      ),
                      "em": Style(
                        fontSize: FontSize.medium, color: Colors.white, fontWeight: FontWeight.w400,
                      ),
                      "div": Style(
                        fontSize: FontSize.medium, color: Colors.white, fontWeight: FontWeight.w400,
                      ),
                      "table": Style(
                        backgroundColor: const Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                      ),
                      "tr": Style(
                        border: const Border(bottom: const BorderSide(color: Colors.grey)),
                      ),
                      "th": Style(
                        padding: const EdgeInsets.all(6),
                        backgroundColor: Colors.grey,
                      ),
                      "td": Style(
                        padding: const EdgeInsets.all(6),
                        alignment: Alignment.topLeft,
                      ),
                      "h1": Style(color: Colors.red),
                    }),
              ],
            ),
            const Divider(color: Colors.white, height: 20, thickness: 0.5),
            Row(
              children: [
                Icon(
                  Icons.thumb_up_alt_rounded,
                  color: datas[index].likedByUs!
                  ? Colors.white
                  : Colors.grey,
                ),
                const SizedBox(width: 5.0),
                Text(
                  "0",
                  style: TextStyle(fontSize: 14, color: datas[index].likedByUs!
                      ? Colors.white
                      : Colors.grey),
                ),

              ],
            )
          ],
        ),
      );
    }),
  );
}
