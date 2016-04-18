package com.example.david.tests;

import android.os.AsyncTask;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class MainActivity extends AppCompatActivity {

    private TextView tvOut;
    private List<String> mItems;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        tvOut = (TextView) findViewById(R.id.tvOut);
        mItems = new ArrayList<>();
    }

    public void eatMemory(View view) {
        MyTask task = new MyTask();
        task.execute();
    }

    public void releaseMemory(View view) {
        mItems.clear();
    }

    class MyTask extends AsyncTask<String, String, String> {

        @Override
        protected String doInBackground(String... params) {
            for (int i = 0; i < 20; i++) {
                for (int j = 0; j < 10000; j++) {
                    mItems.add("Item " + i + ":" + j);
                }
                publishProgress("Number of items: " + mItems.size());
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
            return null;
        }

        @Override
        protected void onProgressUpdate(String... values) {
            super.onProgressUpdate(values);
            tvOut.setText(values[0]);
            Toast.makeText(MainActivity.this, values[0], Toast.LENGTH_SHORT).show();
        }

    }

}
