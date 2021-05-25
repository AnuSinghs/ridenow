const onCheckboxClick = (e) => {
  const currentCheckbox = e.currentTarget;
  const id = currentCheckbox.value;
  const targetId = `#journey_listing_ids_${id}`;
  document.querySelector(targetId).checked = currentCheckbox.checked;
}

const journeyEdit = () => {
  if (document.querySelector('.journey-edit')) {
    const listingSelects = document.querySelectorAll('.listing-select');

    listingSelects.forEach(checkbox => {
      checkbox.addEventListener('click', onCheckboxClick)
    })
  }
}

export default journeyEdit;