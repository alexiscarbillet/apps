package com.app.aclunarcalendar;

import android.os.Bundle;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

public class MainActivity extends AppCompatActivity {

    private TextView moonPhaseTextView;
    private TextView nextFullMoonTextView;
    private TextView nextNewMoonTextView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        moonPhaseTextView = findViewById(R.id.moonPhaseTextView);
        nextFullMoonTextView = findViewById(R.id.nextFullMoonTextView);
        nextNewMoonTextView = findViewById(R.id.nextNewMoonTextView);

        // Get the current date
        Date currentDate = Calendar.getInstance().getTime();

        // Calculate and display moon phase
        String moonPhase = calculateMoonPhase(currentDate);
        moonPhaseTextView.setText("Moon Phase: " + moonPhase);

        // Calculate and display the date of the next full moon
        Date nextFullMoonDate = calculateNextFullMoon(currentDate);
        SimpleDateFormat sdf = new SimpleDateFormat("MMMM dd, yyyy", Locale.getDefault());
        nextFullMoonTextView.setText("Next Full Moon: " + sdf.format(nextFullMoonDate));

        // Calculate and display the date of the next new moon
        Date nextNewMoonDate = calculateNextNewMoon(currentDate);
        nextNewMoonTextView.setText("Next New Moon: " + sdf.format(nextNewMoonDate));
    }

    private String calculateMoonPhase(Date date) {
        // Lunar cycle is approximately 29.53058867 days
        // Start from a known new moon date (e.g., January 6, 2000)
        long daysSinceNewMoon = (date.getTime() - 946684800000L) / 86400000L;
        int phase = (int) (daysSinceNewMoon % 29.53058867);

        // Determine the moon phase
        if (phase < 1 || phase > 29) {
            return "New Moon (Phase 1/29)";
        } else if (phase < 8) {
            return "First Quarter Waxing Crescent (Phase " + phase + "/29)";
        } else if (phase < 15) {
            return "Full Moon (Phase " + phase + "/29)";
        } else if (phase < 16) {
            return "Full Moon Waxing Gibbous (Phase " + phase + "/29)";
        } else if (phase < 22) {
            return "Last Quarter Waning Gibbous (Phase " + phase + "/29)";
        } else {
            return "New Moon Waning Crescent (Phase " + phase + "/29)";
        }
    }

    private Date calculateNextFullMoon(Date currentDate) {
        // Lunar cycle is approximately 29.53058867 days
        // Calculate days until the next full moon
        long daysToNextFullMoon = (long) (15 - (currentDate.getTime() - 946684800000L) / 86400000L % 29.53058867);
        // Calculate date of the next full moon
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(currentDate);
        calendar.add(Calendar.DAY_OF_YEAR, (int) daysToNextFullMoon);
        return calendar.getTime();
    }

    private Date calculateNextNewMoon(Date currentDate) {
        // Lunar cycle is approximately 29.53058867 days
        // Calculate days until the next new moon
        long daysToNextNewMoon = (long) (29.53058867 - (currentDate.getTime() - 1670880000000L) / 86400000L % 29.53058867);

        // Calculate date of the next new moon
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(currentDate);
        calendar.add(Calendar.DAY_OF_YEAR, (int) daysToNextNewMoon);
        return calendar.getTime();
    }
}
