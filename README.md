# instamojodemo

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


// Map to store remarks associated with question IDs
Map<String, String> questionRemarks = {};

// Function to show the remark dialog box
Future<void> showRemarkDialog(BuildContext context, String questionCode) async {
  TextEditingController remarkController = TextEditingController();
  
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Enter Remark'),
        content: TextField(
          controller: remarkController,
          decoration: InputDecoration(
            hintText: 'Type your remark here',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Save the remark to the map
              if (remarkController.text.isNotEmpty) {
                questionRemarks[questionCode] = remarkController.text;
              }
              Navigator.of(context).pop();
            },
            child: Text('Save'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );
}

// Main Widget Build with the ListView
@override
Widget build(BuildContext context) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: state.getQuestionsResponse?.bCOnBoardingQuestions?.length ?? 0,
    itemBuilder: (context, index) {
      List bCOnBoardingQuestions = state.getQuestionsResponse?.bCOnBoardingQuestions ?? [];

      return OuterCardCheckList(
        title: bCOnBoardingQuestions[index]?.bCOnboardingQuestion ?? "",
        lowerWidget: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            YesNoCheckListWidget(
              onChanged: (value) async {
                if (value != null) {
                  String questionCode = bCOnBoardingQuestions[index]?.qid?.toString() ?? "";
                  String createdBy = "H3619";

                  // Add or update the answer in the model
                  var existingItem = bconboardingQuestionAnsList.firstWhere(
                    (item) => item.questionCode == questionCode,
                    orElse: () => null,
                  );

                  if (existingItem != null) {
                    existingItem.bcQuestionAns = value.toString();
                  } else {
                    bconboardingQuestionAnsList.add(
                      BCOnboardingQuestionAnsModel(
                        questionCode: questionCode,
                        bcQuestionAns: value.toString(),
                        questionRemark: "", // Remark will be updated dynamically
                        createdBy: createdBy,
                      ),
                    );
                  }

                  // Show the remark dialog box after selection
                  await showRemarkDialog(context, questionCode);

                  // Update the model with the entered remark
                  if (questionRemarks.containsKey(questionCode)) {
                    existingItem?.questionRemark = questionRemarks[questionCode]!;
                  }

                  // Debugging purpose
                  print(bconboardingQuestionAnsList.map((e) => e.toJson()).toList());
                }
              },
            ),
          ],
        ),
      );
    },
  );
}
