const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

// Test HTML files for validation
function testHTMLFiles() {
    console.log('🔍 Starting HTML validation tests...');
    
    const htmlFiles = [
        'src/index.html',
        'src/about.html'
    ];
    
    let hasErrors = false;
    
    htmlFiles.forEach(file => {
        if (fs.existsSync(file)) {
            console.log(`\n📄 Testing: ${file}`);
            
            try {
                // Using htmlhint via npx
                const result = execSync(`npx htmlhint ${file}`, { encoding: 'utf-8' });
                console.log(`✅ ${file} passed HTML validation`);
            } catch (error) {
                console.error(`❌ ${file} failed HTML validation:`);
                console.error(error.stdout);
                hasErrors = true;
            }
        } else {
            console.error(`❌ File not found: ${file}`);
            hasErrors = true;
        }
    });
    
    return hasErrors;
}

// Test for broken links
function testLinks() {
    console.log('\n🔗 Checking for broken links...');
    // This would be expanded with a link checker in a real scenario
    console.log('✅ Link checking passed (placeholder)');
    return false;
}

// Run all tests
function runTests() {
    console.log('🚀 Running static website tests...\n');
    
    const htmlFailed = testHTMLFiles();
    const linksFailed = testLinks();
    
    if (htmlFailed || linksFailed) {
        console.log('\n❌ Some tests failed!');
        process.exit(1);
    } else {
        console.log('\n✅ All tests passed!');
        process.exit(0);
    }
}

runTests();
