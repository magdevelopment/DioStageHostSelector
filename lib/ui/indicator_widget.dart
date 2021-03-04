import 'package:flutter/material.dart';
import 'package:dio_stage_host_selector/repository/proxy_repository.dart';
import 'package:dio_stage_host_selector/repository/stage_repository.dart';
import 'package:dio_stage_host_selector/ui/selector_dialog.dart';

class StageHostIndicatorWidget extends StatelessWidget {
  final String defaultUrl;
  final StageRepository stageRepository;
  final ProxyRepository proxyRepository;

  const StageHostIndicatorWidget({
    Key? key,
    required this.defaultUrl,
    required this.stageRepository,
    required this.proxyRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) => StageHostSelectorDialog(
            stageRepository: stageRepository,
            proxyRepository: proxyRepository,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(8),
        color: Colors.black38,
        child: Row(
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                stream: stageRepository.selectedUrlStream,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return Text(
                    snapshot.data ?? defaultUrl,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  );
                },
              ),
            ),
            StreamBuilder(
              stream: proxyRepository.selectedProxyStream,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  return Text('+ proxy');
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
