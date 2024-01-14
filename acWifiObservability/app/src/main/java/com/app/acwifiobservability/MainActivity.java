package com.app.acwifiobservability;

import android.content.Context;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Bundle;
import android.os.Handler;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;


public class MainActivity extends AppCompatActivity {

    private TextView ssidTextView, bssidTextView, ipAddressTextView, linkSpeedTextView;
    private WifiManager wifiManager;
    private Handler handler;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Initialize UI components
        ssidTextView = findViewById(R.id.ssidTextView);
        bssidTextView = findViewById(R.id.bssidTextView);
        ipAddressTextView = findViewById(R.id.ipAddressTextView);
        linkSpeedTextView = findViewById(R.id.linkSpeedTextView);

        // Initialize WifiManager
        wifiManager = (WifiManager) getApplicationContext().getSystemService(Context.WIFI_SERVICE);

        // Initialize Handler for periodic updates
        handler = new Handler();
        startRepeatingTask();

    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        stopRepeatingTask();
    }

    Runnable runnable = new Runnable() {
        @Override
        public void run() {
            updateWifiInfo();
            handler.postDelayed(this, 20000); // 20 seconds delay
        }
    };

    void startRepeatingTask() {
        handler.postDelayed(runnable, 0);
    }

    void stopRepeatingTask() {
        handler.removeCallbacks(runnable);
    }

    private void updateWifiInfo() {
        WifiInfo wifiInfo = wifiManager.getConnectionInfo();

        String ssid = wifiInfo.getSSID();
        String bssid = wifiInfo.getBSSID();
        int ipAddress = wifiInfo.getIpAddress();
        int linkSpeed = wifiInfo.getLinkSpeed();

        // Update TextViews
        ssidTextView.setText("SSID: " + ssid);
        bssidTextView.setText("BSSID: " + bssid);
        ipAddressTextView.setText("IP Address: " + formatIpAddress(ipAddress));
        linkSpeedTextView.setText("Link Speed: " + linkSpeed + " Mbps");
    }

    private String formatIpAddress(int ipAddress) {
        // Format the IP address obtained from wifiInfo.getIpAddress()
        return String.format("%d.%d.%d.%d",
                (ipAddress & 0xff),
                (ipAddress >> 8 & 0xff),
                (ipAddress >> 16 & 0xff),
                (ipAddress >> 24 & 0xff));
    }

}

