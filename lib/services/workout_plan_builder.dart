// get fitness level
// select workout split
// enter vital details
// submit plan
// show different screen if user already has workout plan

import 'dart:convert';
import 'dart:io';
import 'package:fitster/models/workout_splits.dart';

Future<Map<String, dynamic>> readJsonFile(String filePath) async {
  final file = File(filePath);
  final contents = await file.readAsString();
  final data = json.decode(contents) as Map<String, dynamic>;
  return data;
}

List<MuscleGroup> parseJsonToMuscleGroup({required Map<String, dynamic> data}) {
  List<MuscleGroup> muscleGroups = [];
  String split = data.keys.first;
  data[split].forEach((muscleGroup, value) {
    List<Exercise> exerciseList = [];
    data[split][muscleGroup].forEach((key, value) {
      Exercise newExercise = Exercise(
        name: key,
        sets: value['sets'],
        reps: value['reps'],
        restTime: value['rest'],
      );
      exerciseList.add(newExercise);
    });
    MuscleGroup newMuscleGroup = MuscleGroup(
      group: muscleGroup,
      exercises: [...exerciseList],
    );
    muscleGroups.add(newMuscleGroup);
    exerciseList.clear();
  });
  return muscleGroups;
}

Future<WorkoutSplit> createWorkoutPlan(String workoutSplit) async {
  switch (workoutSplit) {
    case 'bro_split':
      Map<String, dynamic> data = await readJsonFile('../data/bro_split.json');
      List<MuscleGroup> muscleGroup = parseJsonToMuscleGroup(data: data);
      BroSplit broSplit = BroSplit(
        name: 'Bro Split',
        daysOfWeek: 7,
        muscleGroups: muscleGroup,
        targetMuscles: ['chest', 'back', 'shoulders', 'legs', 'arms'],
      );
      return broSplit;
    case 'push_pull_legs':
      Map<String, dynamic> data =
          await readJsonFile('../data/push_pull_legs.json');
      List<MuscleGroup> muscleGroup = parseJsonToMuscleGroup(data: data);
      PushPullLegsSplit pushPullLegsSplit = PushPullLegsSplit(
        name: 'Push-Pull-Legs',
        daysOfWeek: 7,
        muscleGroups: muscleGroup,
        targetMuscles: ['chest-shoulders-triceps', 'back-biceps', 'legs'],
      );
      return pushPullLegsSplit;
    case 'upper_lower':
      Map<String, dynamic> data =
          await readJsonFile('../data/upper_lower.json');
      List<MuscleGroup> muscleGroup = parseJsonToMuscleGroup(data: data);
      UpperLowerSplit upperLowerSplit = UpperLowerSplit(
        name: 'Upper-Lower',
        daysOfWeek: 7,
        muscleGroups: muscleGroup,
        targetMuscles: ['upper body', 'lower body'],
      );
      return upperLowerSplit;
    default:
      throw Exception('Json file not found');
  }
}
