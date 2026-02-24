import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/question.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  final int index;
  final int selectedIndex;
  final bool answered;
  final ValueChanged<int> onSelect;

  const QuestionCard({
    Key? key,
    required this.question,
    required this.index,
    required this.selectedIndex,
    required this.answered,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final letters = ['A', 'B', 'C', 'D', 'E'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // question card with number badge
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF7ECC4),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x22000000),
                    blurRadius: 8,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(20, 36, 20, 20),
              child: Center(
                child: Text(
                  question.text,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.patrickHand(fontSize: 22, height: 1.25, color: const Color(0xFF2E5A4F)),
                ),
              ),
            ),
            Positioned(
              top: -18,
              left: 12,
              child: CircleAvatar(
                radius: 26,
                backgroundColor: Colors.green[800],
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        // options
        Column(
          children: List.generate(question.options.length, (i) {
            final isSelected = selectedIndex == i;
            Color bg() {
              if (!answered) return Colors.white;
              if (i == question.answerIndex) return Colors.green.shade100;
              if (isSelected && i != question.answerIndex) return Colors.red.shade100;
              return Colors.white;
            }

            Color borderColor() {
              if (!answered) return Colors.transparent;
              if (i == question.answerIndex) return Colors.green.shade700;
              if (isSelected && i != question.answerIndex) return Colors.red.shade700;
              return Colors.grey.shade200;
            }

            return AnimatedScale(
              scale: isSelected ? 1.02 : 1.0,
              duration: const Duration(milliseconds: 160),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: InkWell(
                  onTap: answered ? null : () => onSelect(i),
                  borderRadius: BorderRadius.circular(12),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: bg(),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor(), width: 1.5),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0,2)),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7ECC4),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF2E5A4F), width: 1.5),
                            boxShadow: [BoxShadow(color: const Color(0x22000000), blurRadius: 4, offset: Offset(0,2))],
                          ),
                          child: Center(child: Text(letters[i], style: GoogleFonts.patrickHand(fontWeight: FontWeight.bold, color: const Color(0xFF2E5A4F)))),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            question.options[i],
                            style: GoogleFonts.patrickHand(fontSize: 16),
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: answered ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 220),
                          child: Icon(
                            i == question.answerIndex
                                ? Icons.check_circle
                                : (isSelected ? Icons.cancel : Icons.check_circle_outline),
                            color: i == question.answerIndex
                                ? Colors.green
                                : (isSelected ? Colors.red : Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
