shipment = Mollie::Order::Shipment.create(
  order_id: 'ord_kEn1PlbGa',
  lines: [
    {
      id: 'odl_dgtxyl',
      quantity: 1
    },
    {
      id: 'odl_jp31jz'
    }
  ],
  tracking: {
    carrier: 'PostNL',
    code: '3SKABA000000000',
    url: 'http://postnl.nl/tracktrace/?B=3SKABA000000000&P=1016EE&D=NL&T=C'
  }
)
