# Disk Sector Reader

This program is designed to read the first sector of a disk (MBR - Master Boot Record) and display its raw content in a human-readable format. It provides low-level access to the disk to analyze its structure, such as the bootloader code, partition tables, and boot signature.

## Features

- Reads the first sector (sector 0) of a specified disk.
- Displays the raw content of the sector in hexadecimal format.
- Can be used for educational purposes or low-level disk analysis.

## Requirements

- Linux operating system.
- x86-64 architecture.
- Privileged access (root) to read raw disk data.
- Assemble with NASM and link with `ld`.

## How to Build

1. Assemble the program:
    ```bash
    nasm -f elf64 -o read-disk-sector-linux-x64.obj read-disk-sector-linux-x64.nasm
    ```

2. Link the object file to create the executable:
    ```bash
    ld -s -o read-disk-sector-linux-x64.elf64 read-disk-sector-linux-x64.obj
    ```

## How to Run

To run the program, use the following command (it requires `sudo` to access raw disk data):

```bash
sudo ./read-disk-sector-linux-x64.elf64 < /dev/sda | hexdump
```

This will output the raw contents of the first sector of the `/dev/sda` disk, which is typically where the Master Boot Record (MBR) resides.

### Example Output

```bash
0000000 c033 d08e 00bc 8e7c 8ec0 bed8 7c00 00bf
0000010 b906 0200 f3fc 50a4 1c68 cb06 b9fb 0004
...
0000200
```

### Important Notes

- **`/dev/sda`** is an example path. Ensure you specify the correct device if you want to read a different disk.
- The program only reads the first 512-byte sector of the disk. You can modify it to read additional sectors if needed.
- You need to have root privileges (`sudo`) to access raw disk data on most systems.

## License

- This project is licensed under the MIT License - see the [LICENSE](https://github.com/dawciobiel/disk-sector-tools/blob/main/LICENSE) file for details.

## Authors

- **Dawid Bielecki - dawciobiel** - _Initial development and implementation_ - [dawciobiel](https://github.com/dawciobiel)

## Acknowledgments

- Inspiration and guidance from low-level disk programming resources and tutorials.
