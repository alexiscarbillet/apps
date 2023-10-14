package com.app.memo;

import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {
    private EditText inputEditText;
    private TextView resultTextView;
    private Spinner fromSpinner, toSpinner, categorySpinner;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        inputEditText = findViewById(R.id.inputEditText);
        resultTextView = findViewById(R.id.resultTextView);
        fromSpinner = findViewById(R.id.fromSpinner);
        toSpinner = findViewById(R.id.toSpinner);
        categorySpinner = findViewById(R.id.categorySpinner);

        // Define unit options
        String[] lengthUnits = {"Meter", "Foot", "Inch"};
        String[] weightUnits = {"Kilogram", "Gram", "Pound"};
        String[] categories = {"Length", "Weight"};

        // Create adapters for spinners
        ArrayAdapter<String> lengthAdapter = new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, lengthUnits);
        lengthAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);

        ArrayAdapter<String> weightAdapter = new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, weightUnits);
        weightAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);

        ArrayAdapter<String> categoryAdapter = new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, categories);
        categoryAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);

        // Set adapters for the spinners
        categorySpinner.setAdapter(categoryAdapter);
        fromSpinner.setAdapter(lengthAdapter);
        toSpinner.setAdapter(lengthAdapter);

        // Set an OnItemSelectedListener for the categorySpinner
        categorySpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parentView, View selectedItemView, int position, long id) {
                updateUnitSpinners();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parentView) {
                // Do nothing here
            }
        });
    }

    private void updateUnitSpinners() {
        String selectedCategory = categorySpinner.getSelectedItem().toString();

        if (selectedCategory.equals("Length")) {
            fromSpinner.setAdapter(new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, new String[]{"Meter", "Foot", "Inch"}));
            toSpinner.setAdapter(new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, new String[]{"Meter", "Foot", "Inch"}));
        } else if (selectedCategory.equals("Weight")) {
            fromSpinner.setAdapter(new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, new String[]{"Kilogram", "Gram", "Pound"}));
            toSpinner.setAdapter(new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, new String[]{"Kilogram", "Gram", "Pound"}));
        }
    }

    public void convert(View view) {
        double inputValue = Double.parseDouble(inputEditText.getText().toString());
        String fromUnit = fromSpinner.getSelectedItem().toString();
        String toUnit = toSpinner.getSelectedItem().toString();
        double result = convert(inputValue, fromUnit, toUnit);
        resultTextView.setText(String.valueOf(result));
    }

    private double convert(double value, String fromUnit, String toUnit) {
        // Conversion logic for length
        if ((fromUnit.equals("Meter") || fromUnit.equals("Kilogram")) && (toUnit.equals("Foot") || toUnit.equals("Pound"))) {
            return (fromUnit.equals("Meter") ? value * 3.28084 : value * 2.20462);
        } else if ((fromUnit.equals("Meter") || fromUnit.equals("Kilogram")) && (toUnit.equals("Inch") || toUnit.equals("Gram"))) {
            return (fromUnit.equals("Meter") ? value * 39.3701 : value * 1000.0);
        } else if ((fromUnit.equals("Foot") || fromUnit.equals("Pound")) && (toUnit.equals("Meter") || toUnit.equals("Kilogram"))) {
            return (fromUnit.equals("Foot") ? value * 0.3048 : value * 0.453592);
        } else if ((fromUnit.equals("Foot") || fromUnit.equals("Pound")) && (toUnit.equals("Inch") || toUnit.equals("Gram"))) {
            return (fromUnit.equals("Foot") ? value * 12.0 : value * 453.592);
        } else if ((fromUnit.equals("Inch") || fromUnit.equals("Gram")) && (toUnit.equals("Meter") || toUnit.equals("Kilogram"))) {
            return (fromUnit.equals("Inch") ? value * 0.0254 : value * 0.001);
        } else if ((fromUnit.equals("Inch") || fromUnit.equals("Gram")) && (toUnit.equals("Foot") || toUnit.equals("Pound"))) {
            return (fromUnit.equals("Inch") ? value * 0.00220462 : value * 0.00220462);
        } else {
            return value;
        }
    }
}

