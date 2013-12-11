angular.module('vin.filters').filter('humanize', function() {
  return function(input) 
  {
    if(input)
    {
      return input.replace(/_/g, ' ').replace(/(\w+)/g, function(match) { return match.charAt(0).toUpperCase() + match.slice(1).toLowerCase(); });
    }
    else
    {
      return "";
    }
  };
});
