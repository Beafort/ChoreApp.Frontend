

class Chore {
  final int? id;
  final String name;
  final DateTime deadline;
  final bool done;
  final String? group;
  final String? assignedUser;
  final DateTime? createdAt;
  final int? groupId;
  const Chore(
      {this.id,
      required this.name,
      required this.deadline,
      required this.done,
      this.group,
      this.assignedUser,
      this.createdAt,
      this.groupId
      }
    );
  factory Chore.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'name': String name,
        'deadline': String deadlineString,
        'done': bool done,
        'group': String group,
        'assignedUser' : String assignedUser,
        'createdAt' : String createdAtString
      } =>
        Chore(
            id: id,
            name: name,
            deadline: DateTime.parse(deadlineString),
            done: done,
            group : group,
            assignedUser: assignedUser,
            createdAt: DateTime.parse(createdAtString)
        ),
      _ => throw const FormatException('Failed to load json')
    };
  }
}
