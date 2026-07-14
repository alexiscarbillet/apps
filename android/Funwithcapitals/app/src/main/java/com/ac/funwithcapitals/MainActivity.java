package com.ac.funwithcapitals;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

public class MainActivity extends AppCompatActivity {

    private TextView countryTextView;
    private Button[] optionButtons = new Button[4];

    private Map<String, String> countryCapitalMap;
    private List<String> countries;

    private String correctCapital;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        countryTextView = findViewById(R.id.countryTextView);
        optionButtons[0] = findViewById(R.id.optionButton1);
        optionButtons[1] = findViewById(R.id.optionButton2);
        optionButtons[2] = findViewById(R.id.optionButton3);
        optionButtons[3] = findViewById(R.id.optionButton4);

        // Initialize country-capital data
        countryCapitalMap = new HashMap<>();
        addCountriesAndCapitals();

        countries = new ArrayList<>(countryCapitalMap.keySet());

        for (Button button : optionButtons) {
            button.setOnClickListener(this::checkAnswer);
        }

        askQuestion();
    }

    private void askQuestion() {
        // Randomly select a country
        Random random = new Random();
        String country = countries.get(random.nextInt(countries.size()));
        correctCapital = countryCapitalMap.get(country);

        countryTextView.setText("What is the capital of " + country + " ?");

        List<String> options = new ArrayList<>(countryCapitalMap.values());
        options.remove(correctCapital);
        Collections.shuffle(options);

        // Pick three incorrect options and add the correct one
        List<String> quizOptions = new ArrayList<>();
        quizOptions.add(correctCapital);
        for (int i = 0; i < 3; i++) {
            quizOptions.add(options.get(i));
        }
        Collections.shuffle(quizOptions);

        for (int i = 0; i < 4; i++) {
            optionButtons[i].setText(quizOptions.get(i));
        }
    }

    private void checkAnswer(View view) {
        Button clickedButton = (Button) view;
        String answer = clickedButton.getText().toString();

        if (answer.equals(correctCapital)) {
            Toast.makeText(this, "Correct!", Toast.LENGTH_SHORT).show();
        } else {
            Toast.makeText(this, "Wrong! The correct answer is " + correctCapital, Toast.LENGTH_SHORT).show();
        }

        askQuestion();
    }

    private void addCountriesAndCapitals() {
        countryCapitalMap.put("Afghanistan", "Kabul");
        countryCapitalMap.put("Albania", "Tirana");
        countryCapitalMap.put("Algeria", "Algiers");
        countryCapitalMap.put("Andorra", "Andorra la Vella");
        countryCapitalMap.put("Angola", "Luanda");
        countryCapitalMap.put("Antigua and Barbuda", "St. John's");
        countryCapitalMap.put("Argentina", "Buenos Aires");
        countryCapitalMap.put("Armenia", "Yerevan");
        countryCapitalMap.put("Australia", "Canberra");
        countryCapitalMap.put("Austria", "Vienna");
        countryCapitalMap.put("Azerbaijan", "Baku");
        countryCapitalMap.put("Bahamas", "Nassau");
        countryCapitalMap.put("Bahrain", "Manama");
        countryCapitalMap.put("Bangladesh", "Dhaka");
        countryCapitalMap.put("Barbados", "Bridgetown");
        countryCapitalMap.put("Belarus", "Minsk");
        countryCapitalMap.put("Belgium", "Brussels");
        countryCapitalMap.put("Belize", "Belmopan");
        countryCapitalMap.put("Benin", "Porto-Novo");
        countryCapitalMap.put("Bhutan", "Thimphu");
        countryCapitalMap.put("Bolivia", "Sucre");
        countryCapitalMap.put("Bosnia and Herzegovina", "Sarajevo");
        countryCapitalMap.put("Botswana", "Gaborone");
        countryCapitalMap.put("Brazil", "Brasília");
        countryCapitalMap.put("Brunei", "Bandar Seri Begawan");
        countryCapitalMap.put("Bulgaria", "Sofia");
        countryCapitalMap.put("Burkina Faso", "Ouagadougou");
        countryCapitalMap.put("Burundi", "Gitega");
        countryCapitalMap.put("Cabo Verde", "Praia");
        countryCapitalMap.put("Cambodia", "Phnom Penh");
        countryCapitalMap.put("Cameroon", "Yaoundé");
        countryCapitalMap.put("Canada", "Ottawa");
        countryCapitalMap.put("Central African Republic", "Bangui");
        countryCapitalMap.put("Chad", "N'Djamena");
        countryCapitalMap.put("Chile", "Santiago");
        countryCapitalMap.put("China", "Beijing");
        countryCapitalMap.put("Colombia", "Bogotá");
        countryCapitalMap.put("Comoros", "Moroni");
        countryCapitalMap.put("Congo, Democratic Republic of the", "Kinshasa");
        countryCapitalMap.put("Congo, Republic of the", "Brazzaville");
        countryCapitalMap.put("Costa Rica", "San José");
        countryCapitalMap.put("Croatia", "Zagreb");
        countryCapitalMap.put("Cuba", "Havana");
        countryCapitalMap.put("Cyprus", "Nicosia");
        countryCapitalMap.put("Czech Republic", "Prague");
        countryCapitalMap.put("Denmark", "Copenhagen");
        countryCapitalMap.put("Djibouti", "Djibouti");
        countryCapitalMap.put("Dominica", "Roseau");
        countryCapitalMap.put("Dominican Republic", "Santo Domingo");
        countryCapitalMap.put("East Timor", "Dili");
        countryCapitalMap.put("Ecuador", "Quito");
        countryCapitalMap.put("Egypt", "Cairo");
        countryCapitalMap.put("El Salvador", "San Salvador");
        countryCapitalMap.put("Equatorial Guinea", "Malabo");
        countryCapitalMap.put("Eritrea", "Asmara");
        countryCapitalMap.put("Estonia", "Tallinn");
        countryCapitalMap.put("Eswatini", "Mbabane");
        countryCapitalMap.put("Ethiopia", "Addis Ababa");
        countryCapitalMap.put("Fiji", "Suva");
        countryCapitalMap.put("Finland", "Helsinki");
        countryCapitalMap.put("France", "Paris");
        countryCapitalMap.put("Gabon", "Libreville");
        countryCapitalMap.put("Gambia", "Banjul");
        countryCapitalMap.put("Georgia", "Tbilisi");
        countryCapitalMap.put("Germany", "Berlin");
        countryCapitalMap.put("Ghana", "Accra");
        countryCapitalMap.put("Greece", "Athens");
        countryCapitalMap.put("Grenada", "St. George's");
        countryCapitalMap.put("Guatemala", "Guatemala City");
        countryCapitalMap.put("Guinea", "Conakry");
        countryCapitalMap.put("Guinea-Bissau", "Bissau");
        countryCapitalMap.put("Guyana", "Georgetown");
        countryCapitalMap.put("Haiti", "Port-au-Prince");
        countryCapitalMap.put("Honduras", "Tegucigalpa");
        countryCapitalMap.put("Hungary", "Budapest");
        countryCapitalMap.put("Iceland", "Reykjavik");
        countryCapitalMap.put("India", "New Delhi");
        countryCapitalMap.put("Indonesia", "Jakarta");
        countryCapitalMap.put("Iran", "Tehran");
        countryCapitalMap.put("Iraq", "Baghdad");
        countryCapitalMap.put("Ireland", "Dublin");
        countryCapitalMap.put("Israel", "Jerusalem");
        countryCapitalMap.put("Italy", "Rome");
        countryCapitalMap.put("Jamaica", "Kingston");
        countryCapitalMap.put("Japan", "Tokyo");
        countryCapitalMap.put("Jordan", "Amman");
        countryCapitalMap.put("Kazakhstan", "Nur-Sultan");
        countryCapitalMap.put("Kenya", "Nairobi");
        countryCapitalMap.put("Kiribati", "Tarawa");
        countryCapitalMap.put("Korea, North", "Pyongyang");
        countryCapitalMap.put("Korea, South", "Seoul");
        countryCapitalMap.put("Kosovo", "Pristina");
        countryCapitalMap.put("Kuwait", "Kuwait City");
        countryCapitalMap.put("Kyrgyzstan", "Bishkek");
        countryCapitalMap.put("Laos", "Vientiane");
        countryCapitalMap.put("Latvia", "Riga");
        countryCapitalMap.put("Lebanon", "Beirut");
        countryCapitalMap.put("Lesotho", "Maseru");
        countryCapitalMap.put("Liberia", "Monrovia");
        countryCapitalMap.put("Libya", "Tripoli");
        countryCapitalMap.put("Liechtenstein", "Vaduz");
        countryCapitalMap.put("Lithuania", "Vilnius");
        countryCapitalMap.put("Luxembourg", "Luxembourg");
        countryCapitalMap.put("Madagascar", "Antananarivo");
        countryCapitalMap.put("Malawi", "Lilongwe");
        countryCapitalMap.put("Malaysia", "Kuala Lumpur");
        countryCapitalMap.put("Maldives", "Malé");
        countryCapitalMap.put("Mali", "Bamako");
        countryCapitalMap.put("Malta", "Valletta");
        countryCapitalMap.put("Marshall Islands", "Majuro");
        countryCapitalMap.put("Mauritania", "Nouakchott");
        countryCapitalMap.put("Mauritius", "Port Louis");
        countryCapitalMap.put("Mexico", "Mexico City");
        countryCapitalMap.put("Micronesia", "Palikir");
        countryCapitalMap.put("Moldova", "Chisinau");
        countryCapitalMap.put("Monaco", "Monaco");
        countryCapitalMap.put("Mongolia", "Ulaanbaatar");
        countryCapitalMap.put("Montenegro", "Podgorica");
        countryCapitalMap.put("Morocco", "Rabat");
        countryCapitalMap.put("Mozambique", "Maputo");
        countryCapitalMap.put("Myanmar", "Naypyidaw");
        countryCapitalMap.put("Namibia", "Windhoek");
        countryCapitalMap.put("Nauru", "Yaren");
        countryCapitalMap.put("Nepal", "Kathmandu");
        countryCapitalMap.put("Netherlands", "Amsterdam");
        countryCapitalMap.put("New Zealand", "Wellington");
        countryCapitalMap.put("Nicaragua", "Managua");
        countryCapitalMap.put("Niger", "Niamey");
        countryCapitalMap.put("Nigeria", "Abuja");
        countryCapitalMap.put("North Macedonia", "Skopje");
        countryCapitalMap.put("Norway", "Oslo");
        countryCapitalMap.put("Oman", "Muscat");
        countryCapitalMap.put("Pakistan", "Islamabad");
        countryCapitalMap.put("Palau", "Ngerulmud");
        countryCapitalMap.put("Panama", "Panama City");
        countryCapitalMap.put("Papua New Guinea", "Port Moresby");
        countryCapitalMap.put("Paraguay", "Asunción");
        countryCapitalMap.put("Peru", "Lima");
        countryCapitalMap.put("Philippines", "Manila");
        countryCapitalMap.put("Poland", "Warsaw");
        countryCapitalMap.put("Portugal", "Lisbon");
        countryCapitalMap.put("Qatar", "Doha");
        countryCapitalMap.put("Romania", "Bucharest");
        countryCapitalMap.put("Russia", "Moscow");
        countryCapitalMap.put("Rwanda", "Kigali");
        countryCapitalMap.put("Saint Kitts and Nevis", "Basseterre");
        countryCapitalMap.put("Saint Lucia", "Castries");
        countryCapitalMap.put("Saint Vincent and the Grenadines", "Kingstown");
        countryCapitalMap.put("Samoa", "Apia");
        countryCapitalMap.put("San Marino", "San Marino");
        countryCapitalMap.put("São Tomé and Príncipe", "São Tomé");
        countryCapitalMap.put("Saudi Arabia", "Riyadh");
        countryCapitalMap.put("Senegal", "Dakar");
        countryCapitalMap.put("Serbia", "Belgrade");
        countryCapitalMap.put("Seychelles", "Victoria");
        countryCapitalMap.put("Sierra Leone", "Freetown");
        countryCapitalMap.put("Singapore", "Singapore");
        countryCapitalMap.put("Slovakia", "Bratislava");
        countryCapitalMap.put("Slovenia", "Ljubljana");
        countryCapitalMap.put("Solomon Islands", "Honiara");
        countryCapitalMap.put("Somalia", "Mogadishu");
        countryCapitalMap.put("South Africa", "Pretoria");
        countryCapitalMap.put("South Sudan", "Juba");
        countryCapitalMap.put("Spain", "Madrid");
        countryCapitalMap.put("Sri Lanka", "Sri Jayawardenepura Kotte");
        countryCapitalMap.put("Sudan", "Khartoum");
        countryCapitalMap.put("Suriname", "Paramaribo");
        countryCapitalMap.put("Sweden", "Stockholm");
        countryCapitalMap.put("Switzerland", "Bern");
        countryCapitalMap.put("Syria", "Damascus");
        countryCapitalMap.put("Taiwan", "Taipei");
        countryCapitalMap.put("Tajikistan", "Dushanbe");
        countryCapitalMap.put("Tanzania", "Dodoma");
        countryCapitalMap.put("Thailand", "Bangkok");
        countryCapitalMap.put("Togo", "Lomé");
        countryCapitalMap.put("Tonga", "Nukuʻalofa");
        countryCapitalMap.put("Trinidad and Tobago", "Port of Spain");
        countryCapitalMap.put("Tunisia", "Tunis");
        countryCapitalMap.put("Turkey", "Ankara");
        countryCapitalMap.put("Turkmenistan", "Ashgabat");
        countryCapitalMap.put("Tuvalu", "Funafuti");
        countryCapitalMap.put("Uganda", "Kampala");
        countryCapitalMap.put("Ukraine", "Kyiv");
        countryCapitalMap.put("United Arab Emirates", "Abu Dhabi");
        countryCapitalMap.put("United Kingdom", "London");
        countryCapitalMap.put("United States", "Washington, D.C.");
        countryCapitalMap.put("Uruguay", "Montevideo");
        countryCapitalMap.put("Uzbekistan", "Tashkent");
        countryCapitalMap.put("Vanuatu", "Port Vila");
        countryCapitalMap.put("Vatican City", "Vatican City");
        countryCapitalMap.put("Venezuela", "Caracas");
        countryCapitalMap.put("Vietnam", "Hanoi");
        countryCapitalMap.put("Yemen", "Sana'a");
        countryCapitalMap.put("Zambia", "Lusaka");
        countryCapitalMap.put("Zimbabwe", "Harare");
    }
}
