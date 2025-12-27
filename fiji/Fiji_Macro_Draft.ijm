// === Fiji preprocessing macro draft ===
// Date: 2025-12-09
// Aim: Process loaded raw data from Ca2+ recording, save it ready for Cell Tracing with .py

// STEP 0: Input file into Fiji (manually for now)

// STEP 1: Split channels
// image>stacks>tools>deinterleave

// STEP 2: Divide images to get a ratio in 32 bit


// Maybe: Autofocus? Or smth like that

// Save result for next step as tiff

// === Calcium imaging preprocessing macro ===
// Assumes: current image = interleaved 2-channel stack
// IMPORTANT: By definition in this project:
//  - Channel 1 (first frame) = 420 nm
//  - Channel 2 (second frame) = 480 nm
// Steps: Deinterleave -> 32-bit -> ratio (Ch2 / Ch1) -> save

macro "Fura_Deinterleave_Ratio" {

    // Remember original window name
    orig = getTitle();

    // --- 1 Deinterleave stack into 2 channels ---
    // Menu equivalent: Image > Stacks > Tools > Deinterleave...
    // Parameter how=2 -> 2 channels
    run("Deinterleave", "how=2");

    // Fiji will create two new stacks: "orig #1" and "orig #2"
    ch1 = orig + " #1";   // TODO: confirm which wavelength this is, probably 420
    ch2 = orig + " #2";   // TODO: confirm which wavelength this is, probably 480

    // --- 2 Convert both channels to 32-bit ---
    selectWindow(ch1);
    run("32-bit");

    selectWindow(ch2);
    run("32-bit");

    // --- 3 Compute ratio image ---
    // Here: ratio = ch2 / ch1
    // Swap ch1/ch2 in the line below if you later find the order is wrong.
    imageCalculator("Divide create 32-bit", ch2, ch1);

    // The new image becomes active; give it a useful name
    ratioName = orig + "_ratio";
    rename(ratioName);

    // --- 4 Ask me where to save & write TIFF ---
    outDir = getDirectory("Choose output folder for ratio image");
    if (outDir != null) {
        saveAs("Tiff", outDir + ratioName + ".tif");
    } else {
        print("No output folder selected, not saving.");
    }
}
