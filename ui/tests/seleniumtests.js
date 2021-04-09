const {Builder, By, Key, until} = require('selenium-webdriver');
const assert = require('assert');

const URL = 'http://localhost:8081/tms/ui';

function sleep(n) {
	console.log('Sleeping ', n, 'ms');
	return new Promise(r => setTimeout(r, n));
}

function closeAlertDialog(driver) {
	console.log('Closing alert dialog');
	return driver.switchTo().alert().accept();
}

(async function example() {

	// Start the selenium webdriver
	console.log('Starting the webdriver');
	const driver = await new Builder().forBrowser('chrome').build();
	await sleep(1000);

	try {

		// Visit TMS site
		console.log('Opening browser to TMS site at following URL: ', URL);
		await driver.get(URL);
		await sleep(1000);

		// Count tickets
		console.log('Counting tickets');
		const numTicketsBegin = (await (driver.findElements(By.className('ticket')))).length;
		console.log('Num tickets: ', numTicketsBegin);

		// Create new ticket
		console.log('Creating new ticket');
		const newTicketTitle = 'SELEN_TITLE';
		const newTicketDescription = 'SELEN_DESCRIPTION';
		const newTicketAuthor = 'SELEN_AUTHOR';
		console.log('Clicking Create Ticket button');
		await (await driver.findElements(By.css('input[value="Create Ticket"]')))[0].click();
		await sleep(1000);
		console.log('Filling in new ticket title:', newTicketTitle);
		await driver.findElement(By.css('.new-ticket .ticket-title input')).sendKeys(newTicketTitle);
		console.log('Filling in new ticket description: ', newTicketDescription);
		await driver.findElement(By.css('.new-ticket .ticket-description input')).sendKeys(newTicketDescription);
		console.log('Filling in new ticket author: ', newTicketAuthor);
		await driver.findElement(By.css('.new-ticket .ticket-author input')).sendKeys(newTicketAuthor);
		await sleep(1000);
		console.log('Clicking Create button');
		await (await driver.findElements(By.css('input[value="Create"]')))[0].click();
		await sleep(500);
		await closeAlertDialog(driver);
		await sleep(1000);

		// Count tickets
		console.log('Counting tickets');
		const numTicketsAfterCreate = (await (driver.findElements(By.className('ticket')))).length;
		console.log('Num tickets: ', numTicketsAfterCreate);
		assert.strictEqual(numTicketsBegin, numTicketsAfterCreate - 1);

		// Find newly created ticket
		console.log('Finding newly created ticket');
		const allTitles = await Promise.all( (await driver.findElements(By.css('.ticket-title input'))).map(el => el.getAttribute('value')) );
		console.log('All ticket titles: ', allTitles);
		const index = allTitles.findIndex(title => title === newTicketTitle);
		console.log('Index of newly created ticket: ', index);
		assert.notStrictEqual(index, -1);

		// Delete newly created ticket
		console.log('Deleting newly created ticket');
		await (await driver.findElements(By.css('input[value="Delete"]')))[index].click();
		await sleep(500);
		await closeAlertDialog(driver);
		await sleep(1000);

		// Count tickets
		console.log('Counting tickets');
		const numTicketsAfterDelete = (await (driver.findElements(By.className('ticket')))).length;
		console.log('Num tickets: ', numTicketsAfterDelete);
		assert.strictEqual(numTicketsBegin, numTicketsAfterDelete);

		console.log('Done!')
	} 
	finally {
		await driver.quit();
	}
})();