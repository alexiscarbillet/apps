package com.app.unitconverter;

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
        String[] temperatureUnits = {"Celsius", "Fahrenheit", "Kelvin"};
        String[] volumeUnits = {"Liter", "Milliliter", "Gallon"};

        // Create adapters for spinners
        ArrayAdapter<String> lengthAdapter = new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, lengthUnits);
        lengthAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);

        ArrayAdapter<String> weightAdapter = new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, weightUnits);
        weightAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);

        ArrayAdapter<String> temperatureAdapter = new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, temperatureUnits);
        temperatureAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);

        ArrayAdapter<String> volumeAdapter = new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, volumeUnits);
        volumeAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);

        // Set adapters for the spinners
        categorySpinner.setAdapter(new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, new String[]{"Length", "Weight", "Temperature", "Volume"}));
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
        } else if (selectedCategory.equals("Temperature")) {
            fromSpinner.setAdapter(new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, new String[]{"Celsius", "Fahrenheit", "Kelvin"}));
            toSpinner.setAdapter(new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, new String[]{"Celsius", "Fahrenheit", "Kelvin"}));
        } else if (selectedCategory.equals("Volume")) {
            fromSpinner.setAdapter(new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, new String[]{"Liter", "Milliliter", "Gallon"}));
            toSpinner.setAdapter(new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, new String[]{"Liter", "Milliliter", "Gallon"}));
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
        if (fromUnit.equals(toUnit) || value == 0) {
            return value; // No conversion needed
        }

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
        } else if ((fromUnit.equals("Celsius") || fromUnit.equals("Fahrenheit") || fromUnit.equals("Kelvin")) &&
                (toUnit.equals("Celsius") || toUnit.equals("Fahrenheit") || toUnit.equals("Kelvin")) && fromUnit != toUnit) {
            return convertTemperature(value, fromUnit, toUnit);
        } else if ((fromUnit.equals("Liter") || fromUnit.equals("Milliliter") || fromUnit.equals("Gallon")) &&
                (toUnit.equals("Liter") || toUnit.equals("Milliliter") || toUnit.equals("Gallon")) && fromUnit != toUnit) {
            return convertVolume(value, fromUnit, toUnit);
        } else {
            return value;
        }
    }

    private double convertTemperature(double value, String fromUnit, String toUnit) {
        if (fromUnit.equals("Celsius") && toUnit.equals("Fahrenheit")) {
            return (value * 9/5) + 32;
        } else if (fromUnit.equals("Celsius") && toUnit.equals("Kelvin")) {
            return value + 273.15;
        } else if (fromUnit.equals("Fahrenheit") && toUnit.equals("Celsius")) {
            return (value - 32) * 5/9;
        } else if (fromUnit.equals("Fahrenheit") && toUnit.equals("Kelvin")) {
            return (value - 32) * 5/9 + 273.15;
        } else if (fromUnit.equals("Kelvin") && toUnit.equals("Celsius")) {
            return value - 273.15;
        } else if (fromUnit.equals("Kelvin") && toUnit.equals("Fahrenheit")) {
            return (value - 273.15) * 9/5 + 32;
        } else {
            return value;
        }
    }

    private double convertVolume(double value, String fromUnit, String toUnit) {
        if (fromUnit.equals("Liter") && toUnit.equals("Milliliter")) {
            return value * 1000;
        } else if (fromUnit.equals("Liter") && toUnit.equals("Gallon")) {
            return value * 0.264172;
        } else if (fromUnit.equals("Milliliter") && toUnit.equals("Liter")) {
            return value * 0.001;
        } else if (fromUnit.equals("Milliliter") && toUnit.equals("Gallon")) {
            return value * 0.000264172;
        } else if (fromUnit.equals("Gallon") && toUnit.equals("Liter")) {
            return value * 3.78541;
        } else if (fromUnit.equals("Gallon") && toUnit.equals("Milliliter")) {
            return value * 3785.41;
        } else {
            return value;
        }
    }
}
