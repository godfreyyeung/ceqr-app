import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { click, find, render } from '@ember/test-helpers';
import hbs from 'htmlbars-inline-precompile';

module('Integration | Component | transportation/data-source-toggle', function(hooks) {
  setupRenderingTest(hooks);

  hooks.beforeEach(async function() {
    this.isRJTW = false;
    this.falseLabel = "Journey To Work";
    this.trueLabel = "Journey To Work";

    await render(hbs`{{transportation/data-source-toggle
      switch=this.isRJTW
      falseLabel=this.falseLabel
      trueLabel=this.trueLabel
    }}`);

  })

  test('it toggles the switch and indicates its state', async function(assert) {

    // get refs to Journey To Work and Reverse Journey To Work buttons.
    let jtwButton  = find('[data-test-censustracts-table-isrjtw="false"]');
    let rjtwButton = find('[data-test-censustracts-table-isrjtw="true"]');

    // Table is in JTW mode on load
    assert.equal(jtwButton.classList.contains('active'), true);
    assert.equal(rjtwButton.classList.contains('active'), false);

    // Table switches to RJTW mode after clicking RJTW button
    await click("[data-test-censustracts-table-isrjtw='true']");

    assert.equal(jtwButton.classList.contains('active'), false);
    assert.equal(rjtwButton.classList.contains('active'), true);

    // Table switches back to JTW mode after clicking JTW button
    await click("[data-test-censustracts-table-isrjtw='false']");

    assert.equal(jtwButton.classList.contains('active'), true);
    assert.equal(rjtwButton.classList.contains('active'), false);


  })

});