package org.yny.sample;

import org.junit.Test;

import static org.junit.Assert.*;

public class LibApiTest {
    
    @Test
    public void usingLibVersion1() {
        LibApi api = new LibApi();
        assertEquals("v1", api.getVersion());
    }

}