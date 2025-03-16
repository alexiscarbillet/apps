package com.ac.advancedwords

import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.google.gson.Gson
import kotlin.random.Random

data class Word(
    val word: String,
    val definition: String
)

class MainActivity : AppCompatActivity() {

    private lateinit var languageTextView: TextView
    private lateinit var wordTextView: TextView
    private lateinit var definitionTextView: TextView
    private lateinit var buttonRandomWord: Button

    private val languages = listOf("Français", "English", "Español", "Русский", "Svenska")
    private var wordsList: List<Word> = emptyList()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // Initialize UI elements
        languageTextView = findViewById(R.id.languageTextView)
        wordTextView = findViewById(R.id.wordTextView)
        definitionTextView = findViewById(R.id.definitionTextView)
        buttonRandomWord = findViewById(R.id.buttonRandomWord)

        val buttons = listOf(
            findViewById<Button>(R.id.buttonFrench),
            findViewById<Button>(R.id.buttonEnglish),
            findViewById<Button>(R.id.buttonSpanish),
            findViewById<Button>(R.id.buttonRussian),
            findViewById<Button>(R.id.buttonSwedish)
        )

        // Language selection buttons
        buttons.forEach { button ->
            button.setOnClickListener {
                val language = button.text.toString()
                loadWords(language)
            }
        }

        // Button to get a new random word
        buttonRandomWord.setOnClickListener {
            displayRandomWord()
        }
    }

    private fun loadWords(language: String) {
        val fileId: Int = when (language) {
            "Français" -> R.raw.french
            "English" -> R.raw.english
            "Español" -> R.raw.spanish
            "Русский" -> R.raw.russian
            "Svenska" -> R.raw.swedish
            else -> R.raw.english // Default to English
        }

        val jsonString = readRawResource(fileId)
        val gson = Gson()
        wordsList = gson.fromJson(jsonString, Array<Word>::class.java).toList()

        if (wordsList.isNotEmpty()) {
            languageTextView.text = "Language: $language"
            displayRandomWord()
        } else {
            wordTextView.text = "No words found!"
            definitionTextView.text = ""
        }
    }

    private fun displayRandomWord() {
        if (wordsList.isNotEmpty()) {
            val randomIndex = Random.nextInt(wordsList.size)
            val word = wordsList[randomIndex]
            wordTextView.text = word.word
            definitionTextView.text = word.definition
        }
    }

    private fun readRawResource(resourceId: Int): String {
        return resources.openRawResource(resourceId).bufferedReader().use { it.readText() }
    }
}
