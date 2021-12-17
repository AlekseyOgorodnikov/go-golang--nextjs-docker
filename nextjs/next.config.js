/** @type {import('next').NextConfig} */
module.exports = {
  async rewrites() {
    // When running Next.js via Node.js (e.g. `dev` mode), proxy API requests
    // to the Go server.
    return [
      {
        source: '/',
        destination: 'http://localhost:8080/',
      },
    ];
  },
};
