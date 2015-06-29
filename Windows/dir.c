
// dir.
// A simple, minimalistic puzzle game.

// This is a small stub exe to run dir on Windows.


#include <windows.h>


int WINAPI
WinMain (HINSTANCE hInstance, HINSTANCE hPrevInstance, LPTSTR lpCmdLine, int nCmdShow)
{
    STARTUPINFO si;
    PROCESS_INFORMATION pi;

    ZeroMemory(&si, sizeof(si));
    si.cb = sizeof(si);
    ZeroMemory(&pi, sizeof(pi));

    char *cmd = "love2d/love.exe dir/Source";

    CreateProcess(NULL,  // No module name (use command line).
         cmd,            // Command line.
         NULL,           // Process handle not inheritable.
         NULL,           // Thread handle not inheritable.
         FALSE,          // Set handle inheritance to FALSE.
         0,              // No creation flags.
         NULL,           // Use parent's environment block.
         NULL,           // Use parent's starting directory.
         &si,            // Pointer to STARTUPINFO structure.
         &pi);           // Pointer to PROCESS_INFORMATION structure.

    return 0;
}

