package com.app.memo;

import android.os.Bundle;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {
    private EditText inputEditText;
    private TextView resultTextView;
    private Spinner fromSpinner, toSpinner;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        inputEditText = findViewById(R.id.inputEditText);
        resultTextView = findViewById(R.id.resultTextView);
        fromSpinner = findViewById(R.id.fromSpinner);
        toSpinner = findViewById(R.id.toSpinner);

        // Define unit options
        String[] units = {"Meter", "Foot", "Inch"};

        // Create adapters for spinners
        ArrayAdapter<String> unitAdapter = new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, units);
        unitAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);

        // Set adapters for spinners
        fromSpinner.setAdapter(unitAdapter);
        toSpinner.setAdapter(unitAdapter);
    }

    public void convert(View view) {
        double inputValue = Double.parseDouble(inputEditText.getText().toString());
        String fromUnit = fromSpinner.getSelectedItem().toString();
        String toUnit = toSpinner.getSelectedItem().toString();
        double result = convertLength(inputValue, fromUnit, toUnit);
        resultTextView.setText(String.valueOf(result));
    }

    private double convertLength(double value, String fromUnit, String toUnit) {
        // Conversion logic
        if (fromUnit.equals("Meter") && toUnit.equals("Foot")) {
            return value * 3.28084;
        } else if (fromUnit.equals("Meter") && toUnit.equals("Inch")) {
            return value * 39.3701;
        } else if (fromUnit.equals("Foot") && toUnit.equals("Meter")) {
            return value * 0.3048;
        } else if (fromUnit.equals("Foot") && toUnit.equals("Inch")) {
            return value * 12.0;
        } else if (fromUnit.equals("Inch") && toUnit.equals("Meter")) {
            return value * 0.0254;
        } else if (fromUnit.equals("Inch") && toUnit.equals("Foot")) {
            return value * 0.0833333;
        } else {
            return value;
        }
    }
}

