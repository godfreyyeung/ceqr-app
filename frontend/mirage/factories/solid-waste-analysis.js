import { Factory, association, trait } from 'ember-cli-mirage';

export default Factory.extend({
  banana: trait({
    project: association({
      borough: 'Bronx'
    }),
    transportation: association({
      hasFastFood: true
    })
  }),
});
