enum DailyTaskStatus { completed, skipped, failed }

class DailyTask {
  final DailyTaskStatus status;
  final int seq;
  final bool isToday;
  final bool isSelected;
  final bool isFuture;
  final bool hasNote;

  DailyTask(
      {this.status,
      this.seq,
      this.isToday,
      this.isSelected,
      this.hasNote,
      this.isFuture});
}
