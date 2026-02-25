package karate.runner;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import com.pacifico.automation.utils.qmetry.QmetryUploader;
import com.pacifico.automation.utils.cucumber.CucumberModifier;


import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;

class TestRunner {

    @Test
    void testParallel() {
        Results results = Runner.path("classpath:resources/features")
                .outputCucumberJson(true)
                .outputJunitXml(true)
                .parallel(5);
                
        String cucumberJson  = CucumberModifier.processDirectory(results.getReportDir());
        new QmetryUploader(cucumberJson); 

        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }

}