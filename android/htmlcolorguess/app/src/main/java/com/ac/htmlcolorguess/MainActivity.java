package com.ac.htmlcolorguess;

import android.graphics.Color;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;
import androidx.appcompat.app.AppCompatActivity;
import java.util.Collections;
import java.util.List;

public class MainActivity extends AppCompatActivity {

    private View colorView;
    private TextView questionText;
    private Button choice1, choice2, choice3, choice4;
    private Colors.ColorItem correctColor;
    private List<Colors.ColorItem> allColors;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        colorView = findViewById(R.id.colorView);
        questionText = findViewById(R.id.questionText);
        choice1 = findViewById(R.id.choice1);
        choice2 = findViewById(R.id.choice2);
        choice3 = findViewById(R.id.choice3);
        choice4 = findViewById(R.id.choice4);

        allColors = Colors.getAllColors();
        setNewQuestion();

        View.OnClickListener choiceClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                checkAnswer(v);
            }
        };

        choice1.setOnClickListener(choiceClickListener);
        choice2.setOnClickListener(choiceClickListener);
        choice3.setOnClickListener(choiceClickListener);
        choice4.setOnClickListener(choiceClickListener);
    }

    private void setNewQuestion() {
        questionText.setText("What is the HTML name of this color?");
        Collections.shuffle(allColors);
        correctColor = allColors.get(0);
        colorView.setBackgroundColor(Color.parseColor(correctColor.getValue()));

        List<Colors.ColorItem> choices = allColors.subList(0, 4);
        Collections.shuffle(choices);

        choice1.setText(choices.get(0).getName());
        choice2.setText(choices.get(1).getName());
        choice3.setText(choices.get(2).getName());
        choice4.setText(choices.get(3).getName());
    }

    private void checkAnswer(View view) {
        Button clickedButton = (Button) view;
        String chosenColorName = clickedButton.getText().toString();

        if (chosenColorName.equals(correctColor.getName())) {
            Toast.makeText(this, "Correct!", Toast.LENGTH_SHORT).show();
        } else {
            Toast.makeText(this, "Wrong! The correct answer is " + correctColor.getName(), Toast.LENGTH_SHORT).show();
        }
        setNewQuestion();
    }
}


