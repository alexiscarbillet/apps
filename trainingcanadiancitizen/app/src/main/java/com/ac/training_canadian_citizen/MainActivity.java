package com.ac.training_canadian_citizen;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;
import android.widget.Toast;
import androidx.appcompat.app.AppCompatActivity;
import java.util.ArrayList;
import java.util.List;

public class MainActivity extends AppCompatActivity {

    private List<Question> questionList;
    private int currentQuestionIndex = 0;
    private int score = 0;
    private TextView scoreTextView;  // Declare the TextView to display the score

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Initialize question list
        questionList = new ArrayList<>();
        loadQuestions();  // Load the 40 questions

        // Set up UI elements
        final TextView questionText = findViewById(R.id.questionText);
        final RadioGroup radioGroup = findViewById(R.id.choicesGroup);
        final RadioButton choice1 = findViewById(R.id.choice1);
        final RadioButton choice2 = findViewById(R.id.choice2);
        final RadioButton choice3 = findViewById(R.id.choice3);
        final RadioButton choice4 = findViewById(R.id.choice4);
        final Button nextButton = findViewById(R.id.nextButton);
        scoreTextView = findViewById(R.id.scoreTextView);

        // Display the first question
        displayQuestion(questionText, radioGroup, choice1, choice2, choice3, choice4);

        // Button click listener to check answer and go to the next question
        nextButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                RadioButton selectedRadioButton = findViewById(radioGroup.getCheckedRadioButtonId());
                if (selectedRadioButton != null) {
                    String selectedAnswer = selectedRadioButton.getText().toString();
                    Question currentQuestion = questionList.get(currentQuestionIndex);

                    // Check if the selected answer is correct
                    if (selectedAnswer.equals(currentQuestion.getCorrectAnswer())) {
                        score++;
                    }

                    // Update the score TextView
                    scoreTextView.setText("Score: " + score + " / " + questionList.size());

                    // Move to the next question
                    currentQuestionIndex++;

                    if (currentQuestionIndex < questionList.size()) {
                        // Display next question
                        displayQuestion(questionText, radioGroup, choice1, choice2, choice3, choice4);
                    } else {
                        // If no more questions, show final score
                        Toast.makeText(MainActivity.this, "Your score: " + score + " / " + questionList.size(), Toast.LENGTH_LONG).show();
                    }

                    // Clear the radio button selection
                    radioGroup.clearCheck();
                }
            }
        });
    }

    // Method to display a question
    private void displayQuestion(TextView questionText, RadioGroup radioGroup, RadioButton choice1, RadioButton choice2, RadioButton choice3, RadioButton choice4) {
        Question currentQuestion = questionList.get(currentQuestionIndex);
        questionText.setText(currentQuestion.getQuestionText());
        String[] choices = currentQuestion.getChoices();
        choice1.setText(choices[0]);
        choice2.setText(choices[1]);
        choice3.setText(choices[2]);
        choice4.setText(choices[3]);
    }

    // Method to load 40 questions
    private void loadQuestions() {
        questionList.add(new Question("What is the capital city of Canada?", new String[]{"Montreal", "Ottawa", "Toronto", "Vancouver"}, "Ottawa"));
        questionList.add(new Question("Who is the head of state in Canada?", new String[]{"The Prime Minister", "The Governor General", "The Queen", "The Premier"}, "The Queen"));
        questionList.add(new Question("What is the name of the national anthem of Canada?", new String[]{"O Canada", "The Maple Leaf Forever", "God Save the Queen", "This Land is Your Land"}, "O Canada"));
        questionList.add(new Question("When did Canada become a country?", new String[]{"1776", "1867", "1914", "1945"}, "1867"));
        questionList.add(new Question("What is the national animal of Canada?", new String[]{"The Moose", "The Beaver", "The Bear", "The Eagle"}, "The Beaver"));
        questionList.add(new Question("Who was the first Prime Minister of Canada?", new String[]{"William Lyon Mackenzie King", "John A. Macdonald", "Pierre Trudeau", "Lester B. Pearson"}, "John A. Macdonald"));
        questionList.add(new Question("Which ocean borders Canada to the east?", new String[]{"Atlantic Ocean", "Pacific Ocean", "Arctic Ocean", "Indian Ocean"}, "Atlantic Ocean"));
        questionList.add(new Question("Which ocean borders Canada to the west?", new String[]{"Atlantic Ocean", "Pacific Ocean", "Arctic Ocean", "Indian Ocean"}, "Pacific Ocean"));
        questionList.add(new Question("What is the official language of Quebec?", new String[]{"English", "French", "Spanish", "Mandarin"}, "French"));
        questionList.add(new Question("How many provinces are there in Canada?", new String[]{"8", "9", "10", "11"}, "10"));
        questionList.add(new Question("Which of the following is NOT a Canadian province?", new String[]{"Ontario", "Quebec", "California", "Alberta"}, "California"));
        questionList.add(new Question("What is the currency of Canada?", new String[]{"Pound", "Dollar", "Peso", "Euro"}, "Dollar"));
        questionList.add(new Question("Who was the first woman to become Prime Minister of Canada?", new String[]{"Kim Campbell", "Margaret Trudeau", "Ellen Fairclough", "Joan Fraser"}, "Kim Campbell"));
        questionList.add(new Question("What is the name of the national parliament of Canada?", new String[]{"The Senate", "The House of Commons", "The Parliament of Canada", "The National Assembly"}, "The Parliament of Canada"));
        questionList.add(new Question("Where is the CN Tower located?", new String[]{"Montreal", "Ottawa", "Toronto", "Vancouver"}, "Toronto"));
        questionList.add(new Question("What is the official residence of the Prime Minister of Canada?", new String[]{"Rideau Hall", "24 Sussex Drive", "The Fairmont Royal York", "Parliament Hill"}, "24 Sussex Drive"));
        questionList.add(new Question("What is the highest mountain in Canada?", new String[]{"Mount Logan", "Mount Everest", "Mount McKinley", "Mount Robson"}, "Mount Logan"));
        questionList.add(new Question("Which animal is on the Canadian 5-cent coin?", new String[]{"Beaver", "Moose", "Bear", "Loon"}, "Beaver"));
        questionList.add(new Question("What is the name of Canada’s national police force?", new String[]{"Royal Canadian Police", "Royal Mounted Police", "National Guard", "Canadian Forces"}, "Royal Mounted Police"));
        questionList.add(new Question("In which year was the Canadian flag adopted?", new String[]{"1927", "1965", "1980", "1990"}, "1965"));
        questionList.add(new Question("Which Canadian city is known as 'The City of Gardens'?", new String[]{"Montreal", "Ottawa", "Victoria", "Calgary"}, "Victoria"));
        questionList.add(new Question("What does the maple leaf represent?", new String[]{"The history of Canada", "The beauty of Canada", "Canada’s flora and fauna", "Canadian sovereignty"}, "Canadian sovereignty"));
        questionList.add(new Question("Which province is known as 'The Land of 100,000 Lakes'?", new String[]{"Ontario", "Quebec", "Manitoba", "British Columbia"}, "Manitoba"));
        questionList.add(new Question("In what year did Canada become a fully independent country?", new String[]{"1867", "1917", "1931", "1982"}, "1982"));
        questionList.add(new Question("What is the most populous city in Canada?", new String[]{"Vancouver", "Montreal", "Ottawa", "Toronto"}, "Toronto"));
        questionList.add(new Question("Who is the current Prime Minister of Canada?", new String[]{"Justin Trudeau", "Stephen Harper", "Brian Mulroney", "John A. Macdonald"}, "Justin Trudeau"));
        questionList.add(new Question("What is the official language of Canada?", new String[]{"English only", "French only", "English and French", "English, French, and Indigenous languages"}, "English and French"));
        questionList.add(new Question("Which of these is a symbol of Canada?", new String[]{"The Bald Eagle", "The Maple Leaf", "The Lion", "The Kangaroo"}, "The Maple Leaf"));
        questionList.add(new Question("How many territories does Canada have?", new String[]{"2", "3", "4", "5"}, "3"));
        questionList.add(new Question("Which war did Canada participate in as part of the British Empire?", new String[]{"World War I", "World War II", "The Korean War", "All of the above"}, "All of the above"));
        questionList.add(new Question("What is the title of Canada's national anthem?", new String[]{"God Save the Queen", "The Maple Leaf Forever", "O Canada", "This Land is Your Land"}, "O Canada"));
        questionList.add(new Question("What is Canada’s national motto?", new String[]{"Strength in Unity", "A Mari Usque Ad Mare", "Peace, Order, and Good Government", "From Sea to Shining Sea"}, "A Mari Usque Ad Mare"));
        questionList.add(new Question("In which year did the first official Canadian census take place?", new String[]{"1500", "1700", "1851", "1871"}, "1871"));
        questionList.add(new Question("What is the largest province in Canada by land area?", new String[]{"Ontario", "Quebec", "British Columbia", "Newfoundland and Labrador"}, "Quebec"));
        questionList.add(new Question("What is the official name of Canada’s Constitution?", new String[]{"The British North America Act", "The Charter of Rights and Freedoms", "The Canada Act", "The Statute of Westminster"}, "The Canada Act"));
        questionList.add(new Question("Which Canadian city is famous for the Calgary Stampede?", new String[]{"Calgary", "Vancouver", "Edmonton", "Montreal"}, "Calgary"));
        questionList.add(new Question("What is the national flower of Canada?", new String[]{"The Rose", "The Lily", "The Maple Leaf", "The Orchid"}, "The Lily"));
        questionList.add(new Question("What year was the Canadian Charter of Rights and Freedoms signed?", new String[]{"1967", "1982", "1991", "2001"}, "1982"));
        questionList.add(new Question("Which animal is on the Canadian 25-cent coin?", new String[]{"Loon", "Beaver", "Maple Leaf", "Moose"}, "Moose"));
        questionList.add(new Question("Which animal is on the Canadian 1 dollar coin?", new String[]{"Loon", "Beaver", "Maple Leaf", "Loon"}, "Moose"));
        questionList.add(new Question("Which animal is on the Canadian 10-cent coin?", new String[]{"Loon", "Ship", "Maple Leaf", "Loon"}, "Ship"));
        questionList.add(new Question("Which animal is on the Canadian 2 dollars coin?", new String[]{"Loon", "Ship", "Maple Leaf", "Polar bear"}, "Polar bear"));
        questionList.add(new Question("What is the population of Canada?", new String[]{"10 million", "25 million", "38 million", "50 million"}, "38 million"));
    }

    // Question class to hold question data
    public static class Question {
        private String questionText;
        private String[] choices;
        private String correctAnswer;

        public Question(String questionText, String[] choices, String correctAnswer) {
            this.questionText = questionText;
            this.choices = choices;
            this.correctAnswer = correctAnswer;
        }

        public String getQuestionText() {
            return questionText;
        }

        public String[] getChoices() {
            return choices;
        }

        public String getCorrectAnswer() {
            return correctAnswer;
        }
    }
}


