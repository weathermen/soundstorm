import { template } from "lodash"

export default async function(name) {
  const source = await import(`../templates/${name}`)

  return template(source)
}
