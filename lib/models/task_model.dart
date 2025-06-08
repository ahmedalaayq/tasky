class TaskModel {
  TaskModel({
    required this.taskName,
    required this.taskDescription,
    required this.isHighPriority,
    this.isDone = false,
    required this.id,
  });

  final String taskName;
  final String taskDescription;
  final bool isHighPriority;
  bool isDone;
  final int id;

  //TODO: implement toJson

  Map<String, dynamic> toJson() {
    return {
      "taskName": taskName,
      "taskDescription": taskDescription,
      "isHighPriority": isHighPriority,
      "isDone": isDone,
      "id" : id,
    };
  }

  //TODO: implement fromJson

  factory TaskModel.fromJson(Map<String, dynamic> map) {
    return TaskModel(
      taskName: map['taskName'],
      taskDescription: map['taskDescription'],
      isHighPriority: map['isHighPriority'],
      isDone: map['isDone'] ?? false,
      id:map['id'],
    );
  }

  @override
  String toString() {
    return 'TaskModel{taskName: $taskName, taskDescription: $taskDescription, isHighPriority: $isHighPriority, isDone: $isDone, id: $id}';
  }
}
