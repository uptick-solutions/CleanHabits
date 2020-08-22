import 'package:flutter/material.dart';
import 'package:heatmap_calendar/time_utils.dart';
import 'package:heatmap_calendar/week_columns.dart';
import 'package:heatmap_calendar/week_labels.dart';

class HeatMapCalendar2 extends StatelessWidget {
  static const double COLUMN_COUNT = 11;
  static const double ROW_COUNT = 8;
  static const double EDGE_SIZE = 4;

  /// The labels identifying the initials of the days of the week
  /// Defaults to [TimeUtils.defaultWeekLabels]
  final List<String> weekDaysLabels;

  /// The labels identifying the months of a year
  /// Defaults to [TimeUtils.defaultMonthsLabels]
  final List<String> monthsLabels;

  /// The inputs that will fill the calendar with data
  final Map<DateTime, int> input;

  /// The thresholds which will map the given [input] to a color
  ///
  /// Make sure to map starting on number 1, so the user might notice the difference between
  /// a day that had no input and one that had
  /// Example: {1: Colors.green[100], 20: Colors.green[200], 40: Colors.green[300]}
  final Map<int, Color> colorThresholds;

  /// The size of each item of the calendar
  final double squareSize;

  /// The opacity of the text when the user double taps the widget
  final double textOpacity;

  /// The color of the texts in the weeks/months labels
  final Color labelTextColor;

  /// The color of the text that identifies the days
  final Color dayTextColor;

  /// Helps avoiding overspacing issues
  final double safetyMargin;

  double currentOpacity = 0;
  final bool displayDates;

  HeatMapCalendar2({
    Key key,
    @required this.input,
    @required this.colorThresholds,
    this.weekDaysLabels: TimeUtils.defaultWeekLabels,
    this.monthsLabels: TimeUtils.defaultMonthsLabels,
    this.squareSize: 16,
    this.textOpacity: 0.2,
    this.labelTextColor: Colors.black,
    this.dayTextColor: Colors.black,
    this.safetyMargin: 0,
    this.displayDates = false,
  }) : super(key: key);

  /// Calculates the right amount of columns to create based on [maxWidth]
  ///
  /// returns the number of columns that the widget should have
  int getColumnsToCreate(double maxWidth) {
    assert(maxWidth > (2 * (HeatMapCalendar2.EDGE_SIZE + this.squareSize)));

    // The given size of a square + the size of the margin
    final double widgetWidth = this.squareSize + HeatMapCalendar2.EDGE_SIZE;
    return (maxWidth - this.safetyMargin) ~/ widgetWidth;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return InkWell(
          onDoubleTap: () {},
          child: Container(
            height: (this.squareSize + HeatMapCalendar2.EDGE_SIZE) *
                (HeatMapCalendar2.ROW_COUNT + 1),
            width: constraints.maxWidth,
            child: Row(
              children: <Widget>[
                WeekLabels(
                  weekDaysLabels: this.weekDaysLabels,
                  squareSize: this.squareSize,
                  labelTextColor: this.labelTextColor,
                ),
                WeekColumns(
                  squareSize: this.squareSize,
                  labelTextColor: this.labelTextColor,
                  input: this.input,
                  colorThresholds: this.colorThresholds,
                  currentOpacity: currentOpacity,
                  monthLabels: this.monthsLabels,
                  dayTextColor: this.dayTextColor,
                  columnsToCreate: getColumnsToCreate(constraints.maxWidth) - 1,
                  date: DateTime.now(),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}