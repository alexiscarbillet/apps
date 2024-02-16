package com.ac.tictactoe;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.GridLayout;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {

    private Button[][] buttons = new Button[3][3];
    private boolean player1Turn = true;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        GridLayout gridLayout = findViewById(R.id.gridLayout);

        // Initialize buttons and set onClickListener
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                String buttonID = "button" + (i * 3 + j + 1);
                int resID = getResources().getIdentifier(buttonID, "id", getPackageName());
                buttons[i][j] = findViewById(resID);
                buttons[i][j].setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        onGridButtonClick((Button) v);
                    }
                });
            }
        }
    }

    private void onGridButtonClick(Button button) {
        if (button.getText().toString().equals("")) {
            if (player1Turn) {
                button.setText("X");
                button.setTextColor(getResources().getColor(android.R.color.holo_blue_dark)); // Set 'X' color to blue
            } else {
                button.setText("O");
                button.setTextColor(getResources().getColor(android.R.color.holo_red_dark)); // Set 'O' color to red
            }
            if (checkForWinner()) {
                if (player1Turn) {
                    showToast("Player 1 wins!");
                } else {
                    showToast("Player 2 wins!");
                }
                resetBoard();
            } else if (isBoardFull()) {
                showToast("It's a draw!");
                resetBoard();
            } else {
                player1Turn = !player1Turn;
            }
        } else {
            showToast("Invalid move");
        }
    }


    private boolean checkForWinner() {
        // Check rows
        for (int i = 0; i < 3; i++) {
            if (buttons[i][0].getText().equals(buttons[i][1].getText())
                    && buttons[i][0].getText().equals(buttons[i][2].getText())
                    && !buttons[i][0].getText().toString().equals("")) {
                return true;
            }
        }

        // Check columns
        for (int i = 0; i < 3; i++) {
            if (buttons[0][i].getText().equals(buttons[1][i].getText())
                    && buttons[0][i].getText().equals(buttons[2][i].getText())
                    && !buttons[0][i].getText().toString().equals("")) {
                return true;
            }
        }

        // Check diagonals
        if (buttons[0][0].getText().equals(buttons[1][1].getText())
                && buttons[0][0].getText().equals(buttons[2][2].getText())
                && !buttons[0][0].getText().toString().equals("")) {
            return true;
        }

        if (buttons[0][2].getText().equals(buttons[1][1].getText())
                && buttons[0][2].getText().equals(buttons[2][0].getText())
                && !buttons[0][2].getText().toString().equals("")) {
            return true;
        }

        return false;
    }

    private boolean isBoardFull() {
        // Check if the board is full (no empty cells)
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                if (buttons[i][j].getText().toString().equals("")) {
                    return false;
                }
            }
        }
        return true;
    }

    private void resetBoard() {
        // Reset the text of all buttons to an empty string
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                buttons[i][j].setText("");
            }
        }
        player1Turn = true;
    }

    private void showToast(String message) {
        Toast.makeText(this, message, Toast.LENGTH_SHORT).show();
    }
}
