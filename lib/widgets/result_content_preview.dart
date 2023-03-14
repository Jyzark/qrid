import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:regexpattern/regexpattern.dart';

class ResultContentPreview extends StatelessWidget {
  const ResultContentPreview({
    super.key,
    required this.captureData,
  });

  final BarcodeCapture? captureData;

  @override
  Widget build(BuildContext context) {
    if (captureData!.barcodes.first.rawValue!.isUrl()) {
      return Column(
        children: [
          URLPreview(link: captureData!.barcodes.first.rawValue!),
          const SizedBox(height: 20),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}

class URLPreview extends StatelessWidget {
  const URLPreview({
    super.key,
    required this.link,
  });

  final String link;

  @override
  Widget build(BuildContext context) {
    return AnyLinkPreview.builder(
      link: link,
      placeholderWidget: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color.fromARGB(255, 238, 238, 238),
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 6.4,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 200, 200, 200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 6,
                      color: Color.fromARGB(255, 114, 114, 114),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'Loading...',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
      errorWidget: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color.fromARGB(255, 238, 238, 238),
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 6.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/preview_failed.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'Unable to load preview',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
      itemBuilder: (context, metadata, image) {
        ImageProvider<Object> resultImage() {
          if (metadata.image != null) {
            return NetworkImage(metadata.image!);
          } else {
            return const AssetImage('assets/images/image_broken.png');
          }
        }

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color.fromARGB(255, 238, 238, 238),
          ),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 6.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: resultImage(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  metadata.title != null ? metadata.title! : 'No Title',
                  maxLines: 2,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  metadata.desc != null ? metadata.desc! : 'No description...',
                  maxLines: 2,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 114, 114, 114),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
