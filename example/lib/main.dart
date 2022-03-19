import 'package:dio/dio.dart';
import 'package:dio_stage_host_selector/dio_stage_host_selector.dart';
import 'package:flutter/material.dart';

import 'dio/dio_factory.dart';
import 'dio/stream_interceptor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StageHostSelectorComponent.init(DioFactory.baseUrl);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Dio client;
  late Stream<List<String>> logStream;

  @override
  void initState() {
    super.initState();
    final interceptor = StreamInterceptor();
    logStream = interceptor.logsSubject;

    client = DioFactory.buildClient();
    client.interceptors.add(interceptor);
  }

  void _testRequest() async {
    try {
      await client.get('users', queryParameters: {'id': 'test'});
    } catch (e) {
      //ignored
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Http Logger'),
        bottom: PreferredSize(
          child: StageHostSelectorComponent.buildIndicator(context),
          preferredSize: Size(double.infinity, 16),
        ),
      ),
      body: StreamBuilder(
        stream: logStream,
        initialData: <String>[],
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              final item = snapshot.data?[index] ?? '-';
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(item),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _testRequest,
        tooltip: 'Test Request',
        child: Icon(Icons.network_check),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
