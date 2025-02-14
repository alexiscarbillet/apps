package com.ac.finspanSheets;

import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {

    private int numberOfPlayers;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Initialize number of players to 2
        numberOfPlayers = 2;

        // Get table layout
        final TableLayout tableLayout = findViewById(R.id.tableLayout);

        // Set up table
        setUpTable(tableLayout);
    }

    private void setUpTable(final TableLayout tableLayout) {
        tableLayout.removeAllViews();

        // Array of row names
        final String[] rowNames = {"Week 1 achievement", "Week 2 achievement", "Week 3 achievement", "GAME END points (yellow)", "Points printed on fish", "Eggs: 1 pt each", "Young: 1 pt each", "Schools: 6 pts each", "Consumed fish: 1pt each", "Total"};

        // Create table rows for row names and initialize total array
        final TextView[][] totalTextViews = new TextView[10][numberOfPlayers]; // Rows: 10 (including the "Total" row), Columns: numberOfPlayers
        final EditText[][] editTexts = new EditText[9][numberOfPlayers]; // Exclude the "Total" row
        for (int i = 0; i < 10; i++) {
            TableRow tableRow = new TableRow(this);
            TextView textView = new TextView(this);
            textView.setText(rowNames[i]);
            tableRow.addView(textView);
            if (i < 9) { // Exclude the "Total" row
                for (int j = 0; j < numberOfPlayers; j++) {
                    final EditText editText = new EditText(this);
                    editText.setHint("Enter value");
                    final int row = i;
                    final int col = j;
                    editText.addTextChangedListener(new TextWatcher() {
                        @Override
                        public void beforeTextChanged(CharSequence s, int start, int count, int after) {}

                        @Override
                        public void onTextChanged(CharSequence s, int start, int before, int count) {}

                        @Override
                        public void afterTextChanged(Editable s) {
                            updateTotal(tableLayout, rowNames, totalTextViews, editTexts);
                        }
                    });
                    editTexts[i][j] = editText;
                    tableRow.addView(editText);
                }
                TextView totalTextView = new TextView(this);
                totalTextView.setText("0"); // Initialize total to 0
                totalTextViews[i][0] = totalTextView; // Set the first column of each row's total
                tableRow.addView(totalTextView);
            } else { // For the "Total" row
                for (int j = 0; j < numberOfPlayers; j++) {
                    // Add TextViews instead of EditTexts
                    TextView totalTextView = new TextView(this);
                    totalTextView.setText("0");
                    totalTextViews[i][j] = totalTextView; // Set the total TextView for each player in the last row
                    tableRow.addView(totalTextView);
                }
            }
            tableLayout.addView(tableRow);
        }

        // Update total after initializing EditText fields
        updateTotal(tableLayout, rowNames, totalTextViews, editTexts);
    }

    private void updateLastRowSum(TableLayout tableLayout, String[] rowNames, TextView[][] totalTextViews, EditText[][] editTexts) {
        int numberOfColumns = editTexts[0].length;
        for (int col = 0; col < numberOfColumns; col++) {
            int columnTotal = 0;
            for (int row = 0; row < 9; row++) {
                EditText editText = editTexts[row][col];
                if (!editText.getText().toString().isEmpty()) {
                    columnTotal += Integer.parseInt(editText.getText().toString());
                }
            }
            // Update the total TextView in the last row for the current column
            totalTextViews[9][col].setText(String.valueOf(columnTotal)); // Row 9 corresponds to the "Total" row
        }
    }

    private void updateTotal(TableLayout tableLayout, String[] rowNames, TextView[][] totalTextViews, EditText[][] editTexts) {
        // Update totals for each player
        for (int j = 0; j < numberOfPlayers; j++) {
            int playerTotal = 0;
            for (int i = 0; i < 9; i++) {
                EditText editText = editTexts[i][j];
                if (!editText.getText().toString().isEmpty()) {
                    playerTotal += Integer.parseInt(editText.getText().toString());
                }
            }
            // Update the total TextView for each player
            totalTextViews[9][j].setText(String.valueOf(playerTotal)); // Line 9 corresponds to the "Total" column
        }

        // Update totals for each column
        updateLastRowSum(tableLayout, rowNames, totalTextViews, editTexts);
    }
}
