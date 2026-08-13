import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../models/topic.dart';
import '../models/question.dart';

final List<Subject> placeholderSubjects = [
  const Subject(
    id: 's1',
    name: 'Physics',
    description: 'Motion, forces, energy & more',
    color: Color(0xFF4A90D9),
    icon: Icons.bolt,
    topicCount: 2,
  ),
  const Subject(
    id: 's2',
    name: 'Biology',
    description: 'Cells, genetics, ecosystems',
    color: Color(0xFF2ECC71),
    icon: Icons.biotech,
    topicCount: 1,
  ),
  const Subject(
    id: 's3',
    name: 'Chemistry',
    description: 'Atoms, reactions, elements',
    color: Color(0xFFE67E22),
    icon: Icons.science,
    topicCount: 1,
  ),
];

final List<Topic> placeholderTopics = [
  const Topic(
    id: 't1',
    subjectId: 's1',
    title: 'Motion Basics',
    description: 'Speed, velocity & acceleration',
    questionCount: 2,
  ),
  const Topic(
    id: 't2',
    subjectId: 's1',
    title: 'Forces',
    description: 'Newton\'s laws & friction',
    questionCount: 1,
  ),
  const Topic(
    id: 't3',
    subjectId: 's2',
    title: 'Cell Structure',
    description: 'Organelles & their functions',
    questionCount: 1,
  ),
  const Topic(
    id: 't4',
    subjectId: 's3',
    title: 'Periodic Table',
    description: 'Elements & atomic structure',
    questionCount: 1,
  ),
];

final List<Question> placeholderQuestions = [
  const Question(
    id: 'q1',
    topicId: 't1',
    prompt: 'What is the unit of speed?',
    type: QuestionType.multipleChoice,
    options: ['Newton', 'm/s', 'Joule', 'Kelvin'],
    correctOptionIndex: 1,
  ),
  const Question(
    id: 'q2',
    topicId: 't1',
    prompt: 'Velocity has both magnitude and direction.',
    type: QuestionType.trueFalse,
    options: ['True', 'False'],
    correctOptionIndex: 0,
  ),
  const Question(
    id: 'q3',
    topicId: 't2',
    prompt: 'What is the unit of force?',
    type: QuestionType.multipleChoice,
    options: ['Newton', 'Pascal', 'Watt', 'Ohm'],
    correctOptionIndex: 0,
  ),
  const Question(
    id: 'q4',
    topicId: 't3',
    prompt: 'Which organelle is the "powerhouse of the cell"?',
    type: QuestionType.multipleChoice,
    options: ['Nucleus', 'Ribosome', 'Mitochondria', 'Golgi apparatus'],
    correctOptionIndex: 2,
  ),
  const Question(
    id: 'q5',
    topicId: 't4',
    prompt: 'What is the atomic number of Hydrogen?',
    type: QuestionType.multipleChoice,
    options: ['0', '1', '2', '14'],
    correctOptionIndex: 1,
  ),
];