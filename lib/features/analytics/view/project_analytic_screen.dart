import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_management_app/core/utils/base_state.dart';
import 'package:project_management_app/features/analytics/cubit/analytic_cubit.dart';
import 'package:project_management_app/features/projects/model/project_model.dart';
import 'package:project_management_app/features/tasks/model/task_model.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ProjectAnalyticScreen extends StatefulWidget {
  static const String routeName = "/project-analytic";
  final ProjectModel project;

  const ProjectAnalyticScreen({super.key, required this.project});

  @override
  State<ProjectAnalyticScreen> createState() => _ProjectAnalyticScreenState();
}

class _ProjectAnalyticScreenState extends State<ProjectAnalyticScreen> {
  late ProjectModel projectModel;

  @override
  void initState() {
    projectModel = widget.project;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          projectModel.title!,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AnalyticCubit(projectModel.id)),
        ],
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  projectModel.description!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<AnalyticCubit, BaseState>(
                  builder: (context, state) {
                    if (state is BaseSuccessState) {
                      int all = state.response.length;
                      int done = state.response
                          .where((element) => element.state == '1')
                          .toList()
                          .length;
                      return Center(
                        child: Column(
                          children: [
                            SimpleCircularProgressBar(
                              maxValue: all.toDouble(),
                              valueNotifier:
                                  ValueNotifier<double>(done.toDouble()),
                              mergeMode: true,
                              progressColors: const [
                                Colors.cyan,
                                Colors.purple
                              ],
                              onGetText: (double value) {
                                TextStyle centerTextStyle = const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                );
                                return Text(
                                  '${value.toInt()}',
                                  style: centerTextStyle,
                                );
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SfCartesianChart(
                                primaryXAxis: const CategoryAxis(),
                                title: const ChartTitle(text: 'Task Periods '),
                                legend: const Legend(isVisible: true),
                                // Enable tooltip
                                tooltipBehavior: TooltipBehavior(enable: true),
                                series: <CartesianSeries<TaskModel, String>>[
                                  LineSeries<TaskModel, String>(
                                    dataSource: state.response,
                                    xValueMapper: (TaskModel task, _) {
                                      return task.taskName;
                                    },
                                    name: 'Task Period in Days',
                                    dataLabelSettings: const DataLabelSettings(
                                        isVisible: true),
                                    yValueMapper: (TaskModel task, int index) {
                                      final c = DateTime.parse(task.createdAt!);
                                      final d = DateTime.parse(task.deadLine!);
                                      final diff = d.difference(c).inDays;
                                      return diff;
                                    },
                                  )
                                ]),
                          ],
                        ),
                      );
                    }
                    if (state is BaseErrorState) {
                      return Center(
                        child: Text(state.message),
                      );
                    }

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
