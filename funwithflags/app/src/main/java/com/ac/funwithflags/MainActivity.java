package com.ac.funwithflags;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MainActivity extends AppCompatActivity {

    private ImageView flagImageView;
    private Button button1, button2, button3, button4;
    private Map<String, Integer> flagMap;
    private List<String> countries;
    private String correctCountry;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        flagImageView = findViewById(R.id.flagImageView);
        button1 = findViewById(R.id.button1);
        button2 = findViewById(R.id.button2);
        button3 = findViewById(R.id.button3);
        button4 = findViewById(R.id.button4);

        flagMap = new HashMap<>();
        countries = new ArrayList<>();

        // Add flags and country names to the map
        addFlagsToMap();

        // Set click listeners for buttons
        View.OnClickListener answerClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Button clickedButton = (Button) v;
                checkAnswer(clickedButton.getText().toString());
            }
        };

        button1.setOnClickListener(answerClickListener);
        button2.setOnClickListener(answerClickListener);
        button3.setOnClickListener(answerClickListener);
        button4.setOnClickListener(answerClickListener);

        // Show the first question
        showNextQuestion();
    }

    private void addFlagsToMap() {
        flagMap.put("Afghanistan", R.drawable.afghanistan);
        flagMap.put("Albania", R.drawable.albania);
        flagMap.put("Algeria", R.drawable.algeria);
        flagMap.put("Andorra", R.drawable.andorra);
        flagMap.put("Angola", R.drawable.angola);
        flagMap.put("Antigua and Barbuda", R.drawable.antigua_and_barbuda);
        flagMap.put("Argentina", R.drawable.argentina);
        flagMap.put("Armenia", R.drawable.armenia);
        flagMap.put("Australia", R.drawable.australia);
        flagMap.put("Austria", R.drawable.austria);
        flagMap.put("Azerbaijan", R.drawable.azerbaijan);
        flagMap.put("Bahamas", R.drawable.bahamas);
        flagMap.put("Bahrain", R.drawable.bahrain);
        flagMap.put("Bangladesh", R.drawable.bangladesh);
        flagMap.put("Barbados", R.drawable.barbados);
        flagMap.put("Belarus", R.drawable.belarus);
        flagMap.put("Belgium", R.drawable.belgium);
        flagMap.put("Belize", R.drawable.belize);
        flagMap.put("Benin", R.drawable.benin);
        flagMap.put("Bhutan", R.drawable.bhutan);
        flagMap.put("Bolivia", R.drawable.bolivia);
        flagMap.put("Bosnia and Herzegovina", R.drawable.bosnia_and_herzegovina);
        flagMap.put("Botswana", R.drawable.botswana);
        flagMap.put("Brazil", R.drawable.brazil);
        flagMap.put("Brunei", R.drawable.brunei);
        flagMap.put("Burkina Faso", R.drawable.burkina_faso);
        flagMap.put("Burundi", R.drawable.burundi);
        flagMap.put("Cabo Verde", R.drawable.cabo_verde);
        flagMap.put("Cambodia", R.drawable.cambodia);
        flagMap.put("Cameroon", R.drawable.cameroon);
        flagMap.put("Canada", R.drawable.canada);
        flagMap.put("Central African Republic", R.drawable.car);
        flagMap.put("Chad", R.drawable.chad);
        flagMap.put("Chile", R.drawable.chile);
        flagMap.put("China", R.drawable.china);
        flagMap.put("Colombia", R.drawable.colombia);
        flagMap.put("Comoros", R.drawable.comoros);
        flagMap.put("Congo", R.drawable.congo);
        flagMap.put("Costa Rica", R.drawable.costa_rica);
        flagMap.put("Croatia", R.drawable.croatia);
        flagMap.put("Cuba", R.drawable.cuba);
        flagMap.put("Czechia", R.drawable.czechia);
        flagMap.put("Côte d'Ivoire", R.drawable.cote_divoire);
        flagMap.put("Denmark", R.drawable.denmark);
        flagMap.put("Djibouti", R.drawable.djibouti);
        flagMap.put("Dominica", R.drawable.dominica);
        flagMap.put("Dominican Republic", R.drawable.dominican_republic);
        flagMap.put("DPRK", R.drawable.dprk);
        flagMap.put("DRC", R.drawable.drc);
        flagMap.put("Ecuador", R.drawable.ecuador);
        flagMap.put("Egypt", R.drawable.egypt);
        flagMap.put("El Salvador", R.drawable.el_salvador);
        flagMap.put("Equatorial Guinea", R.drawable.equatorial_guinea);
        flagMap.put("Eritrea", R.drawable.eritrea);
        flagMap.put("Estonia", R.drawable.estonia);
        flagMap.put("Eswatini", R.drawable.eswatini);
        flagMap.put("Ethiopia", R.drawable.ethiopia);
        flagMap.put("Fiji", R.drawable.fiji);
        flagMap.put("France", R.drawable.france);
        flagMap.put("Gabon", R.drawable.gabon);
        flagMap.put("Gambia", R.drawable.gambia);
        flagMap.put("Georgia", R.drawable.georgia);
        flagMap.put("Germany", R.drawable.germany);
        flagMap.put("Ghana", R.drawable.ghana);
        flagMap.put("Greece", R.drawable.greece);
        flagMap.put("Grenada", R.drawable.grenada);
        flagMap.put("Guatemala", R.drawable.guatemala);
        flagMap.put("Guinea-Bissau", R.drawable.guinea_bissau);
        flagMap.put("Guinea", R.drawable.guinea);
        flagMap.put("Guyana", R.drawable.guyana);
        flagMap.put("Haiti", R.drawable.haiti);
        flagMap.put("Holy See", R.drawable.holy_see);
        flagMap.put("Honduras", R.drawable.honduras);
        flagMap.put("Hungary", R.drawable.hungary);
        flagMap.put("Iceland", R.drawable.iceland);
        flagMap.put("India", R.drawable.india);
        flagMap.put("Indonesia", R.drawable.indonesia);
        flagMap.put("Iran", R.drawable.iran);
        flagMap.put("Iraq", R.drawable.iraq);
        flagMap.put("Ireland", R.drawable.ireland);
        flagMap.put("Israel", R.drawable.israel);
        flagMap.put("Italy", R.drawable.italy);
        flagMap.put("Jamaica", R.drawable.jamaica);
        flagMap.put("Japan", R.drawable.japan);
        flagMap.put("Jordan", R.drawable.jordan);
        flagMap.put("Kazakhstan", R.drawable.kazakhstan);
        flagMap.put("Kenya", R.drawable.kenya);
        flagMap.put("Kiribati", R.drawable.kiribati);
        flagMap.put("Kuwait", R.drawable.kuwait);
        flagMap.put("Kyrgyzstan", R.drawable.kyrgyzstan);
        flagMap.put("Laos", R.drawable.laos);
        flagMap.put("Latvia", R.drawable.latvia);
        flagMap.put("Lebanon", R.drawable.lebanon);
        flagMap.put("Lesotho", R.drawable.lesotho);
        flagMap.put("Liberia", R.drawable.liberia);
        flagMap.put("Libya", R.drawable.libya);
        flagMap.put("Liechtenstein", R.drawable.liechtenstein);
        flagMap.put("Lithuania", R.drawable.lithuania);
        flagMap.put("Luxembourg", R.drawable.luxembourg);
        flagMap.put("Madagascar", R.drawable.madagascar);
        flagMap.put("Malawi", R.drawable.malawi);
        flagMap.put("Malaysia", R.drawable.malaysia);
        flagMap.put("Maldives", R.drawable.maldives);
        flagMap.put("Mali", R.drawable.mali);
        flagMap.put("Malta", R.drawable.malta);
        flagMap.put("Marshall Islands", R.drawable.marshall_islands);
        flagMap.put("Mauritania", R.drawable.mauritania);
        flagMap.put("Mauritius", R.drawable.mauritius);
        flagMap.put("Mexico", R.drawable.mexico);
        flagMap.put("Micronesia", R.drawable.micronesia);
        flagMap.put("Moldova", R.drawable.moldova);
        flagMap.put("Monaco", R.drawable.monaco);
        flagMap.put("Mongolia", R.drawable.mongolia);
        flagMap.put("Montenegro", R.drawable.montenegro);
        flagMap.put("Morocco", R.drawable.morocco);
        flagMap.put("Mozambique", R.drawable.mozambique);
        flagMap.put("Myanmar", R.drawable.myanmar);
        flagMap.put("Namibia", R.drawable.namibia);
        flagMap.put("Nauru", R.drawable.nauru);
        flagMap.put("Nepal", R.drawable.nepal);
        flagMap.put("Netherlands", R.drawable.netherlands);
        flagMap.put("New Zealand", R.drawable.new_zealand);
        flagMap.put("Nicaragua", R.drawable.nicaragua);
        flagMap.put("Niger", R.drawable.niger);
        flagMap.put("Nigeria", R.drawable.nigeria);
        flagMap.put("North Macedonia", R.drawable.north_macedonia);
        flagMap.put("Norway", R.drawable.norway);
        flagMap.put("Oman", R.drawable.oman);
        flagMap.put("Pakistan", R.drawable.pakistan);
        flagMap.put("Palau", R.drawable.palau);
        flagMap.put("Panama", R.drawable.panama);
        flagMap.put("Papua New Guinea", R.drawable.papua_new_guinea);
        flagMap.put("Paraguay", R.drawable.paraguay);
        flagMap.put("Peru", R.drawable.peru);
        flagMap.put("Philippines", R.drawable.philippines);
        flagMap.put("Poland", R.drawable.poland);
        flagMap.put("Portugal", R.drawable.portugal);
        flagMap.put("Qatar", R.drawable.qatar);
        flagMap.put("Romania", R.drawable.romania);
        flagMap.put("Russia", R.drawable.russia);
        flagMap.put("Rwanda", R.drawable.rwanda);
        flagMap.put("Saint Kitts and Nevis", R.drawable.saint_kitts_and_nevis);
        flagMap.put("Saint Lucia", R.drawable.saint_lucia);
        flagMap.put("Samoa", R.drawable.samoa);
        flagMap.put("San Marino", R.drawable.san_marino);
        flagMap.put("Sao Tome and Principe", R.drawable.sao_tome_and_principe);
        flagMap.put("Saudi Arabia", R.drawable.saudi_arabia);
        flagMap.put("Senegal", R.drawable.senegal);
        flagMap.put("Serbia", R.drawable.serbia);
        flagMap.put("Seychelles", R.drawable.seychelles);
        flagMap.put("Sierra Leone", R.drawable.sierra_leone);
        flagMap.put("Singapore", R.drawable.singapore);
        flagMap.put("Slovakia", R.drawable.slovakia);
        flagMap.put("Slovenia", R.drawable.slovenia);
        flagMap.put("Solomon Islands", R.drawable.solomon_islands);
        flagMap.put("Somalia", R.drawable.somalia);
        flagMap.put("South Africa", R.drawable.south_africa);
        flagMap.put("South Korea", R.drawable.south_korea);
        flagMap.put("South Sudan", R.drawable.south_sudan);
        flagMap.put("Spain", R.drawable.spain);
        flagMap.put("Sri Lanka", R.drawable.sri_lanka);
        flagMap.put("St. Vincent and the Grenadines", R.drawable.st_vincent_grenadines);
        flagMap.put("State of Palestine", R.drawable.state_of_palestine);
        flagMap.put("Suriname", R.drawable.suriname);
        flagMap.put("Sweden", R.drawable.sweden);
        flagMap.put("Switzerland", R.drawable.switzerland);
        flagMap.put("Syria", R.drawable.syria);
        flagMap.put("Tajikistan", R.drawable.tajikistan);
        flagMap.put("Tanzania", R.drawable.tanzania);
        flagMap.put("Thailand", R.drawable.thailand);
        flagMap.put("Timor-Leste", R.drawable.timor_leste);
        flagMap.put("Togo", R.drawable.togo);
        flagMap.put("Tonga", R.drawable.tonga);
        flagMap.put("Trinidad and Tobago", R.drawable.trinidad_and_tobago);
        flagMap.put("Tunisia", R.drawable.tunisia);
        flagMap.put("Turkey", R.drawable.turkey);
        flagMap.put("Turkmenistan", R.drawable.turkmenistan);
        flagMap.put("Tuvalu", R.drawable.tuvalu);
        flagMap.put("United Kingdom", R.drawable.uk);
        flagMap.put("United States", R.drawable.us);
        flagMap.put("Uganda", R.drawable.uganda);
        flagMap.put("Ukraine", R.drawable.ukraine);
        flagMap.put("Uruguay", R.drawable.uruguay);
        flagMap.put("Uzbekistan", R.drawable.uzbekistan);
        flagMap.put("Vanuatu", R.drawable.vanuatu);
        flagMap.put("Venezuela", R.drawable.venezuela);
        flagMap.put("Vietnam", R.drawable.vietnam);
        flagMap.put("Yemen", R.drawable.yemen);
        flagMap.put("Zambia", R.drawable.zambia);
        flagMap.put("Zimbabwe", R.drawable.zimbabwe);

        countries.addAll(flagMap.keySet());
    }

    private void showNextQuestion() {
        Collections.shuffle(countries);
        correctCountry = countries.get(0);
        flagImageView.setImageResource(flagMap.get(correctCountry));

        List<String> options = new ArrayList<>(countries.subList(0, 4));
        Collections.shuffle(options);

        button1.setText(options.get(0));
        button2.setText(options.get(1));
        button3.setText(options.get(2));
        button4.setText(options.get(3));
    }

    private void checkAnswer(String chosenCountry) {
        if (chosenCountry.equals(correctCountry)) {
            Toast.makeText(this, "Correct!", Toast.LENGTH_SHORT).show();
        } else {
            Toast.makeText(this, "Wrong! Correct answer: " + correctCountry, Toast.LENGTH_SHORT).show();
        }

        showNextQuestion();
    }
}
